extends Node

signal tool_space_landed( tool_card )
signal effect_space_landed( effect_card )
signal tool_box_closed( tool )
signal effect_box_closed( money, spaces )

var in_game_money = 10

var normalEffects = [
	['You see a child selling hot cheetos and feel inspired by his hustle mentality. Move Forward 1!', 0, 1],
	['Geto Money Spreads on you destryoing your reputation Move Backward 1!', 0, -1],
	['Bitcoin goes up! Gain 10 Bands', 10, 0],
	['You got that itch again, Lose 10 Bands', -10, 0],
	['You slip in front of the hoes', 0, -5],
	['Your parlay hit gain 30 Bands', 30, 0],
]
