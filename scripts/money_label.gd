extends Label
@onready var label: Label = $"."

func _ready() -> void:
	label.text = str( SignalBus.in_game_money ) + " BANDS"

func _update_money( money ):
	SignalBus.in_game_money += money
	label.text = str( SignalBus.in_game_money ) + " BANDS"
