extends Node2D

@onready var pink_piece : Sprite2D = $PinkPiece
@onready var blue_piece: Sprite2D = $BluePiece

@onready var lose_screen: Control = $CanvasLayer/LoseScreen
@onready var win_screen: Control = $CanvasLayer/WinScreen
@onready var start_menu: Control = $CanvasLayer/StartMenu



@onready var timer := $Timer
@onready var red_dice := $RedDie
@onready var blue_dice := $BlueDie
@onready var off_white_dice := $OffWhiteDie
@export var game_spaces : Array[Spot]
@export var effect_scenes : Array[PackedScene]
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var label: Label = $CanvasLayer/GojoMoney
var run_emit_tool_space := false
var run_emit_effect_space := false
var run_tool_close := false
var gojo_turn := true


var place : int = -9999
var pink_place : int = 0
var blue_place : int = 0
var number_of_spaces : int

func _ready() -> void:
	number_of_spaces = game_spaces.size()
	SignalBus.tool_box_closed.connect(_on_tool_box_close)
	SignalBus.effect_box_closed.connect(_on_effect_box_close)
	
func _process(delta):
	if run_emit_tool_space:
		SignalBus.tool_space_landed.emit( randi_range(0,5) )
		run_emit_tool_space = false
	if run_emit_effect_space:
		print('sending')
		SignalBus.effect_space_landed.emit( randi_range(0,5) )
		run_emit_effect_space = false
	if pink_place <= 0:
		pink_place = 0
	if blue_place <= 0:
		blue_place = 0
	if SignalBus.geto_money <= 0:
		win_screen.visible = true
	if SignalBus.in_game_money <= 0:
		lose_screen.visible = true
		 
		

func _on_dice_dice_has_rolled(roll: Variant) -> void:
	# for testing
	roll = 1
	play_gojo_turn( roll )
			
func gojo_move( place ) -> void:
	var tween = create_tween()
	print('gojo move')
	tween.tween_property(pink_piece, "position", game_spaces[ place ].position,0.1 )
	print('gojo move')
	timer.start()
	await timer.timeout
	
func geto_move( place ) -> void:
	var tween = create_tween()
	print('geto move')
	tween.tween_property(blue_piece, "position", game_spaces[ place ].position, 0.1 )
	print('geto move')
	timer.start()
	await timer.timeout

func move_by_num_spaces_gojo( num_spaces ) -> void:
	var new_place = pink_place + num_spaces
	print('num space: ' + str( num_spaces ))
	print('new_place: ' + str( new_place ))
	print('pink_place: ' + str( pink_place ))
	if new_place < pink_place:
		while num_spaces != 0 and (pink_place - 1 >= 0) :
			await gojo_move( pink_place - 1 )
			pink_place -= 1
			num_spaces += 1
			
	else:
		while num_spaces != 0 and ( pink_place < game_spaces.size() ) :
			await gojo_move( pink_place + 1 )
			pink_place += 1
			num_spaces -= 1
			
func move_by_num_spaces_geto( num_spaces ) -> void:
	var new_place = blue_place + num_spaces
	print('num space: ' + str( num_spaces ))
	print('new_place: ' + str( new_place ))
	print('blue_place: ' + str( blue_place ))
	if new_place < blue_place:
		while num_spaces != 0 and (blue_place - 1 >= 0) :
			await geto_move( blue_place - 1 )
			blue_place -= 1
			num_spaces += 1
			
	else:
		while num_spaces != 0 and ( blue_place < game_spaces.size() ) :
			await geto_move( blue_place + 1 )
			blue_place += 1
			num_spaces -= 1
	
	
func _on_tool_box_close( tool ) -> void:
	await get_tree().process_frame
	if gojo_turn:
		gojo_turn = false
		play_geto_turn()
	blue_dice.can_click = true
	red_dice.can_click = true
	off_white_dice.can_click = true
	#TODO: add tool to item list
	
func _on_effect_box_close( money, spaces ) -> void:
	await get_tree().process_frame
	label.call("_update_money", money, gojo_turn)
	if spaces != 0:
		print('tryna move back')
		if gojo_turn:
			print('gojo')
			await move_by_num_spaces_gojo( spaces )
		else:
			print('geto')
			await move_by_num_spaces_geto( spaces )
		print('moved back')
	if gojo_turn:
		gojo_turn = false
		play_geto_turn()
	blue_dice.can_click = true
	red_dice.can_click = true
	off_white_dice.can_click = true

func play_gojo_turn( roll ) -> void:
	print('pink place: ' + str( pink_place ) )
	print('pink place: ' + str( pink_place) ) 
	gojo_turn = true
	while roll != 0:
		pink_place += 1
		await gojo_move( pink_place )
		roll -= 1
	if roll == 0:
		if game_spaces[ pink_place ].direction == Direction.SpaceType.TOOL:
			run_emit_tool_space = true
			#Load it
			var effect_box = preload("res://scenes/ToolPopUpBox.tscn")
			#Instance it
			var effect = effect_box.instantiate()
			#Add it
			canvas_layer.add_child(effect)
			#Position it
		elif game_spaces[ pink_place ].direction == Direction.SpaceType.EFFECT:
			var odds := randi_range(1,10)
			if odds >= 11:
				effect_scenes.shuffle()
				#Load it
				var tool_box = effect_scenes.front()
				#Instance it
				var tool = tool_box.instantiate()
				#Add it
				canvas_layer.add_child(tool)
				#Position it
			else:
				run_emit_effect_space = true
				# Load it
				var effect_box = preload("res://scenes/NormalEffects/EffectPopUpBox.tscn")
				# Instance it
				var effect = effect_box.instantiate()
				# Add it
				canvas_layer.add_child(effect)
				# Position it
		elif game_spaces[ pink_place ].direction == Direction.SpaceType.WIN:
			win_screen.visible = true
		else:
			if gojo_turn:
				gojo_turn = false
				play_geto_turn()
		
			
			
	

func play_geto_turn() -> void :
	print( "geto roll: " + str( SignalBus.blue_dice_roll ) )
	print('pink place: ' + str( pink_place ) )
	print('pink place: ' + str( pink_place) ) 
	var roll = SignalBus.blue_dice_roll
	while roll != 0:
		blue_place += 1
		await geto_move( blue_place )
		roll -= 1
	if roll == 0:
		if game_spaces[ blue_place ].direction == Direction.SpaceType.TOOL:
			run_emit_tool_space = true
			#Load it
			var effect_box = preload("res://scenes/ToolPopUpBox.tscn")
			#Instance it
			var effect = effect_box.instantiate()
			#Add it
			canvas_layer.add_child(effect)
			#Position it
		elif game_spaces[ blue_place ].direction == Direction.SpaceType.EFFECT:
			var odds := randi_range(1,10)
			if odds >= 11:
				effect_scenes.shuffle()
				#Load it
				var tool_box = effect_scenes.front()
				#Instance it
				var tool = tool_box.instantiate()
				#Add it
				canvas_layer.add_child(tool)
				#Position it
			else:
				run_emit_effect_space = true
				# Load it
				var effect_box = preload("res://scenes/NormalEffects/EffectPopUpBox.tscn")
				# Instance it
				var effect = effect_box.instantiate()
				# Add it
				canvas_layer.add_child(effect)
				# Position it
		elif game_spaces[ blue_place ].direction == Direction.SpaceType.WIN:
			lose_screen.visible = true
		else:
			blue_dice.can_click = true
			red_dice.can_click = true
			off_white_dice.can_click = true
	
	
	
	
