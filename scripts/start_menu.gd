extends Control
@onready var start_menu: Control = $"."


func _on_buy_in_button_down() -> void:
	SignalBus.out_of_game_money -= 15
	hide()
	get_parent().get_parent().start_game()
	


func _on_quit_button_pressed() -> void:
	get_tree().quit()
