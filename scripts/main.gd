extends Node2D

@onready var pink_piece : Sprite2D = $PinkPiece
@onready var timer := $Timer
@onready var dice := $Dice
@export var game_spaces : Array[Spot]
@export var effect_scenes : Array[PackedScene]
@onready var canvas_layer: CanvasLayer = $CanvasLayer
var run_emit := false



var place : int = 1
var number_of_spaces : int

func _ready() -> void:
	number_of_spaces = game_spaces.size()
	
func _process(delta):
	if run_emit:
		SignalBus.tool_space_landed.emit( randi_range(1,5) )
		run_emit = false
		

func _on_dice_dice_has_rolled(roll: Variant) -> void:
	# for testing
	#roll = 1
	while roll != 0:
		await move( place )
		place += 1
		roll -= 1
	if roll == 0:
		print('checking')
		print( game_spaces )
		print( place )
		print(game_spaces[ place ].direction)
		print(Direction.SpaceType.BACK)
		if game_spaces[ place - 1 ].direction == Direction.SpaceType.BACK:
			var two_spaces_back = place - 3
			print('back')
			while place != two_spaces_back:
					place -= 1
					await move( place )
		if game_spaces[ place - 1 ].direction == Direction.SpaceType.TOOL:
			print('tool')
			
			run_emit = true
			#Load it
			var effect_box = preload("res://scenes/EffectPopUpBox.tscn")
			#Instance it
			var effect = effect_box.instantiate()
			#Add it
			canvas_layer.add_child(effect)
			#Position it
		elif game_spaces[ place - 1 ].direction == Direction.SpaceType.EFFECT:
			effect_scenes.shuffle()
			#Load it
			var effect_box = effect_scenes.front()
			#Instance it
			var effect = effect_box.instantiate()
			#Add it
			canvas_layer.add_child(effect)
			#Position it
		else:
			SignalBus.can_click = true
			
			
		
		
func move( place ) -> void:
	var tween = create_tween()
	tween.tween_property(pink_piece, "position", game_spaces[ place ].position, 1 )
	timer.start()
	await timer.timeout
