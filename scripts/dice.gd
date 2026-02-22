extends Sprite2D

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer
@export var can_click = true
signal dice_has_rolled( roll )




func _on_timer_timeout() -> void:
	var dice_roll : int = randi_range( 1, 6 )
	print( dice_roll )
	animation_player.play( str( dice_roll ) )
	emit_signal( "dice_has_rolled", dice_roll )


func _on_texture_button_button_down() -> void:
	if Input.is_action_just_pressed("ui_click") and can_click:
		can_click = false
		animation_player.play("roll")
		timer.start()
