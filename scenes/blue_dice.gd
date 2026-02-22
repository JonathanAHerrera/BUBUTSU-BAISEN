extends "res://scripts/dice.gd"
func _on_timer_timeout() -> void:
	var dice_roll : int = randi_range( 1, 6 )
	print( dice_roll )
	animation_player.play( str( dice_roll ) )
	SignalBus.blue_dice_roll = dice_roll
	print('blue set')
