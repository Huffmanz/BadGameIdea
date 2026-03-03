extends CanvasLayer

@onready var wave_label: Label = %"Wave Label"
@onready var restart_button: Button = %RestartButton
@onready var quit_button: Button = %QuitButton

func _ready() -> void:
	restart_button.pressed.connect(_on_restart_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	get_tree().paused = true
	
func init(wave_number: int):
	var format_string = "You Survived %d Waves!"
	wave_label.text = format_string % [wave_number]
	
func _on_restart_pressed() -> void:
	ScreenTransition.transition_to_scene("res://levels/world.tscn")
	
func _on_quit_pressed() -> void:
	ScreenTransition.transition_to_scene("res://levels/main_menu.tscn")
	
