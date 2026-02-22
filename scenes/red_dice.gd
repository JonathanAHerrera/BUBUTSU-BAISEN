extends "res://scripts/dice.gd"

func _on_timer_timeout() -> void:
	var dice_roll : int = randi_range( 1, 6 )
	print( dice_roll )
	animation_player.play( str( dice_roll ) )
	SignalBus.red_dice_roll = dice_roll
	emit_signal( "dice_has_rolled", dice_roll )
	print('red set')
