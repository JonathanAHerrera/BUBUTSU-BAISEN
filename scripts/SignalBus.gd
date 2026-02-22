extends Node

signal tool_space_landed( tool_card )
signal effect_space_landed( effect_card )
signal tool_box_closed( tool )
signal effect_box_closed( money, spaces )


var red_dice_roll
var blue_dice_roll
var off_white_dice_roll

var out_of_game_money = 50
var in_game_money = 15
var geto_money = 50

var normalEffects = [
	['You see a child selling hot cheetos and feel inspired by his hustle mentality. Move Forward 1!', -15, 1],
	['Geto Money Spreads on you destryoing your reputation Move Backward 1!', -15, -1],
	['Bitcoin goes up! Gain 10 Bands', -15, 0],
	['You got that itch again, Lose 10 Bands', -15, 0],
	['You slip in front of the hoes. Move back 5 spaces', -15, -5],
	['Your parlay hit gain 30 Bands', -15, 0],
]
