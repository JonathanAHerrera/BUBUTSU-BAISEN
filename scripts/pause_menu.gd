extends Control

@export var controller_path: NodePath
@onready var controller = get_node(controller_path)

func _on_resume_pressed() -> void:
	print('working')
	get_tree().paused = false
	hide()


func _on_back_to_menu_button_pressed() -> void:
	get_tree().paused = false
	hide()
	get_parent().get_parent().go_to_menu()
