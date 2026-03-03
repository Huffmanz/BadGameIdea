extends RigidBody2D
class_name CharacterBase

enum State { IDLE, WALKING, JUMPING, FALLING, SLAMMING }

@export var move_force: float = 5000.0
@export var max_speed: float = 200.0
@export var jump_force: float = 25000.0
@export var air_control: float = 0.3

@onready var ground_check_ray: RayCast2D = $GroundCheck

var lever : RigidBody2D = null

var state: State = State.IDLE
var is_grounded: bool = false
var fall_time: float = 0.0
var move_input: float = 0.0

var save_mass: float = 1.0

func _ready() -> void:
	# RigidBody2D settings
	lock_rotation = true
	gravity_scale = 1.0
	linear_damp = 0.0
	contact_monitor = true
	max_contacts_reported = 4
	save_mass = mass

func _physics_process(delta: float) -> void:
	_check_grounded()
	_update_state(delta)
	_apply_movement(delta)

func _check_grounded() -> void:	
	if ground_check_ray:
		ground_check_ray.force_raycast_update()
		is_grounded = ground_check_ray.is_colliding()
		if is_grounded and not lever:
			lever = ground_check_ray.get_collider() as RigidBody2D
		if state != State.SLAMMING and is_grounded:
			mass = save_mass

func _update_state(delta: float) -> void:
	if is_grounded:
		if abs(linear_velocity.x) > 10:
			state = State.WALKING
		else:
			state = State.IDLE
	else:
		if linear_velocity.y < 0:
			state = State.JUMPING
		elif state != State.SLAMMING:
			state = State.FALLING
			fall_time += delta

func _apply_movement(delta: float) -> void:
	move_input = get_move_input()
	
	if move_input != 0:
		var force_multiplier = 1.0
		if not is_grounded:
			force_multiplier = air_control
		
		var target_velocity = move_input * max_speed
		var velocity_diff = target_velocity - linear_velocity.x
		var force = velocity_diff * move_force * force_multiplier * delta
		apply_central_force(Vector2(force, 0))
	

func jump() -> void:
	if is_grounded:
		apply_central_impulse(Vector2(0, -jump_force))
		state = State.JUMPING

		if lever:
			lever.apply_impulse(Vector2.UP * jump_force / 2.0, global_position)

func start_slam() -> void:
	if not is_grounded and state != State.SLAMMING:
		state = State.SLAMMING
		mass = save_mass * 2.0
		linear_velocity.y = max_speed * 5.0  # Fast downward velocity

func get_move_input() -> float:
	return 0.0
