extends CenterContainer
@onready var label: Label = $PanelContainer/MarginContainer/VBoxContainer/Label
var tool_cards = [ "Sharingan", "Glock", "Piece of lint", "Student Loan Debt", "Infinity Stone", "Donut"]
@onready var timer: Timer = $Timer
@onready var panel_container: PanelContainer = $PanelContainer
var set_effect_card = -1

func _ready() -> void:
	SignalBus.effect_space_landed.connect(_change_text_effect)
	
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_click"):
		panel_container.hide()
		queue_free()
		SignalBus.effect_box_closed.emit( SignalBus.normalEffects[ set_effect_card ][ 1 ], SignalBus.normalEffects[ set_effect_card ][ 2 ] )
		
		
func _change_text_effect( effect_card ):
	print( "WE ARE CHANGING" )
	set_effect_card = effect_card
	label.text = SignalBus.normalEffects[ effect_card ][ 0 ]
	
