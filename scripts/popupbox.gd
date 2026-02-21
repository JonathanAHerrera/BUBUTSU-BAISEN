extends CenterContainer
@onready var label: Label = $PanelContainer/MarginContainer/VBoxContainer/Label



func _on_button_pressed() -> void:
	print('pressing button')
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_click"):
		queue_free()
