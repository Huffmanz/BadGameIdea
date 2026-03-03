extends CanvasLayer

@onready var resume_button: Button = %ResumeButton
@onready var quit_button: Button = %QuitButton
@onready var panel: PanelContainer = %Panel

var is_closing := false

func _ready() -> void:
	get_tree().paused = true
	resume_button.pressed.connect(_resume_pressed)
	quit_button.pressed.connect(_quit_pressed)
	
func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		close()
		get_tree().root.set_input_as_handled()

	
func _resume_pressed() -> void:
	close()
	
func _quit_pressed() -> void:
	ScreenTransition.transition_to_scene("res://levels/main_menu.tscn")

func close():
	if is_closing: 
		return
	is_closing = true
	var tween = create_tween()
	tween.tween_property(panel, "scale", Vector2.ONE, 0)
	tween.tween_property(panel, "scale", Vector2.ZERO, .3)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	await tween.finished
	get_tree().paused = false
	queue_free()
