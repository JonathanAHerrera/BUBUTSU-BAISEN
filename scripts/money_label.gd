extends Label
@onready var label: Label = $"."
@onready var geto_money: Label = $"../GetoMoney"

func _ready() -> void:
	label.text = str( SignalBus.in_game_money ) + " BANDS"
	geto_money.text = str( SignalBus.geto_money ) + " BANDS"

func _update_money( money, gojo_turn ):
	if gojo_turn:
		print('gojo money change')
		SignalBus.in_game_money += money
		label.text = str( SignalBus.in_game_money ) + " BANDS"
	else:
		print('geto monkey change')
		SignalBus.geto_money += money
		geto_money.text = str( SignalBus.geto_money ) + " BANDS"
		
		
