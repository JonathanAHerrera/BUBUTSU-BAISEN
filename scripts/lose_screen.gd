extends Control
@onready var lose_screen: Control = $"."
@onready var start_menu: Control = $"../StartMenu"
@onready var main: Node2D = $"../.."



func _on_menu_button_button_down() -> void:
	start_menu.visible = true
	lose_screen.visible = false
	
	


func _on_play_again_button_button_down() -> void:
	SignalBus.reset_game.emit()
	SignalBus.out_of_game_money -= 15
	lose_screen.visible = false
	main.game_ended = false
