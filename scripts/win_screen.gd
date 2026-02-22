extends Control
@onready var winner_label: Label = $Center/Box/WinnerLabel
@onready var start_menu: Control = $CanvasLayer/StartMenu
@onready var win_screen: Control = $CanvasLayer/WinScreen
signal reset_game
func _ready() -> void:
	winner_label.text = "NOW YOU HAVE " + str( SignalBus.out_of_game_money) + " BANDS"



func _on_menu_button_button_down() -> void:
	start_menu.visible = true
	win_screen.visible = false
	
	


func _on_play_again_button_button_down() -> void:
	SignalBus.reset_game.emit()
	SignalBus.out_of_game_money -= 15
