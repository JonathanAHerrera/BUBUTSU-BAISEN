extends Node2D

@onready var pink_piece : Sprite2D = $PinkPiece
@onready var timer := $Timer
@onready var dice := $Dice
@export var game_spaces : Array[Spot]
@export var effect_scenes : Array[PackedScene]
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var label: Label = $CanvasLayer/Label
var run_emit_tool_space := false
var run_emit_effect_space := false
var run_tool_close := false



var place : int = 0
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
		

func _on_dice_dice_has_rolled(roll: Variant) -> void:
	# for testing
	roll = 1
	while roll != 0:
		place += 1
		await move( place )
		roll -= 1
	if roll == 0:
		if game_spaces[ place ].direction == Direction.SpaceType.BACK:
			var two_spaces_back = place - 2
			while place != two_spaces_back:
					place -= 1
					await move( place )
		if game_spaces[ place ].direction == Direction.SpaceType.TOOL:
			run_emit_tool_space = true
			#Load it
			var effect_box = preload("res://scenes/ToolPopUpBox.tscn")
			#Instance it
			var effect = effect_box.instantiate()
			#Add it
			canvas_layer.add_child(effect)
			#Position it
		elif game_spaces[ place ].direction == Direction.SpaceType.EFFECT:
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
		else:
			print('click allowed')
			dice.can_click = true
func move( place ) -> void:
	var tween = create_tween()
	tween.tween_property(pink_piece, "position", game_spaces[ place ].position, 1 )
	timer.start()
	await timer.timeout

func move_by_num_spaces( num_spaces ) -> void:
	
	var new_place = place + num_spaces
	print( "curr place: " + str( place ) )
	print( "num_spaces: " + str( num_spaces ) )
	if new_place < place:
		while num_spaces != 0 and (place - 1 >= 0) :
			move( place - 1 )
			place -= 1
			num_spaces += 1
	else:
		while num_spaces != 0 and ( place < game_spaces.size() ) :
			move( place + 1 )
			place += 1
			num_spaces -= 1
	
	
func _on_tool_box_close( tool ) -> void:
	await get_tree().process_frame
	print('click allowed')
	dice.can_click = true
	#TODO: add tool to item list
	
func _on_effect_box_close( money, spaces ) -> void:
	await get_tree().process_frame
	label.call("_update_money", money)
	if spaces != 0:
		move_by_num_spaces( spaces )
	dice.can_click = true
	print( 'click allowed' )
	
	
	


func _on_texture_button_button_down() -> void:
	pass # Replace with function body.
