extends CharacterBase
class_name Player

func _physics_process(delta: float) -> void:
	_handle_input()
	super._physics_process(delta)

func _handle_input() -> void:
	if Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("move_up"):
		jump()
	
	if Input.is_action_just_pressed("move_down") and not is_grounded:
		start_slam()

func get_move_input() -> float:
	return Input.get_axis("move_left", "move_right")
