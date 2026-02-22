extends CenterContainer
@onready var label: Label = $PanelContainer/MarginContainer/VBoxContainer/Label
var tool_cards = [ "Sharingan", "Glock", "Piece of lint", "Student Loan Debt", "Infinity Stone", "Donut"]
@onready var timer: Timer = $Timer
@onready var panel_container: PanelContainer = $PanelContainer


func _ready() -> void:
	SignalBus.tool_space_landed.connect(_change_text)

func _on_button_pressed() -> void:
	print('pressing button')
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_click"):
		panel_container.hide()
		timer.start()
		await timer.timeout
		print('freed')
		queue_free()
		SignalBus.can_click = true
		
		
func _change_text( tool_card ):
	print( "WE ARE CHANGING" )
	label.text = "congrats! you got a " + tool_cards[ tool_card ]
	
