extends Control
@onready var start_menu: Control = $"."


func _on_buy_in_button_down() -> void:
	SignalBus.out_of_game_money -= 15
	start_menu.visible = false
	
