extends Label
@onready var label: Label = $"."

func _ready() -> void:
	label.text = "You have " + str( SignalBus.out_of_game_money ) + " BANDS"
