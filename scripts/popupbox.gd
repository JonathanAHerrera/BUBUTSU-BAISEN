extends CenterContainer
@onready var label: Label = $PanelContainer/MarginContainer/VBoxContainer/Label
var tool_cards = [ "Sharingan", "Glock", "Piece of lint", "Student Loan Debt", "Infinity Stone", "Donut"]
@onready var timer: Timer = $Timer
@onready var panel_container: PanelContainer = $PanelContainer
var set_tool_card = -1

func _ready() -> void:
	SignalBus.tool_space_landed.connect(_change_text_tool)
	
func _on_button_pressed() -> void:
	print('pressing button')
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_click"):
		panel_container.hide()
		queue_free()
		SignalBus.tool_box_closed.emit( set_tool_card )
		
		
func _change_text_tool( tool_card ):
	set_tool_card = tool_card
	label.text = "congrats! you got a " + tool_cards[ tool_card ]
	
