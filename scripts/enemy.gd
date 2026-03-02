extends CharacterBase
class_name Enemy

@export var patrol_distance: float = 150.0
@export var jump_chance: float = 0.02
@export var slam_chance: float = 0.05

var start_position: Vector2
var move_direction: float = 1.0
var ai_timer: float = 0.0

func _ready() -> void:
	super._ready()
	start_position = global_position

func _physics_process(delta: float) -> void:
	_handle_ai(delta)
	super._physics_process(delta)

func _handle_ai(delta: float) -> void:
	ai_timer += delta
	
	var distance_from_start = global_position.x - start_position.x
	
	if abs(distance_from_start) > patrol_distance:
		move_direction *= -1
	
	if ai_timer > 1.0:
		ai_timer = 0.0
		
		if randf() < jump_chance and is_grounded:
			jump()
		
		if randf() < slam_chance and not is_grounded and state == State.FALLING:
			start_slam()

func get_move_input() -> float:
	return move_direction * 0.5
