extends RigidBody2D
class_name CharacterBase

enum State { IDLE, WALKING, JUMPING, FALLING, SLAMMING, DASHING }

@export var move_force: float = 5000.0
@export var max_speed: float = 200.0
@export var jump_force: float = 25000.0
@export var air_control: float = 0.3
@export var slam_force: float = 10000.0
@export var dash_force: float = 10000.0

@onready var ground_check_ray: RayCast2D = $GroundCheck
@onready var dash_timer: Timer = $DashTimer

var lever : RigidBody2D = null

var state: State = State.IDLE
var is_grounded: bool = false
var fall_time: float = 0.0
var move_input: float = 0.0

func _ready() -> void:
	# RigidBody2D settings
	lock_rotation = true
	gravity_scale = 1.0
	linear_damp = 0.0
	contact_monitor = true
	max_contacts_reported = 4
	dash_timer.timeout.connect(end_dash)

func end_dash() -> void:
	pass

func _physics_process(delta: float) -> void:
	_check_grounded()
	_update_state(delta)
	_apply_movement(delta)

func _check_grounded() -> void:	
	if lever:
		#facing down by default
		ground_check_ray.look_at(lever.global_position)
		ground_check_ray.rotation -= PI / 2.0
	if ground_check_ray:
		ground_check_ray.force_raycast_update()
		is_grounded = ground_check_ray.is_colliding()
		if is_grounded and not lever:
			lever = ground_check_ray.get_collider() as RigidBody2D
		if state == State.FALLING and is_grounded:
			var offset = global_position - lever.global_position
			lever.apply_impulse(Vector2.DOWN * slam_force * (fall_time + 1.0), offset)

			#find all other characters on the lever and apply an impulse to them
			var characters = lever.get_tree().get_nodes_in_group("character")
			for character in characters:
				if character == self or !character.is_grounded:
					continue
				Utils.launch_character(character, lever, jump_force  / 2.0 * Vector2.DOWN)
		if state == State.SLAMMING and is_grounded:
			GameEvents.emit_camera_shake(10.0)
			#find all other characters on the lever and apply an impulse to them
			var characters = lever.get_tree().get_nodes_in_group("character")
			for character in characters:
				if character == self or !character.is_grounded:
					continue
				Utils.launch_character(character, lever, jump_force  * Vector2.DOWN)
			var offset = global_position - lever.global_position
			lever.apply_impulse(Vector2.DOWN * slam_force * (fall_time + 1.0), offset)


func _update_state(delta: float) -> void:
	if state == State.DASHING:
		return

	if is_grounded:
		fall_time = 0.0
		if abs(linear_velocity.x) > 10:
			state = State.WALKING
		else:
			state = State.IDLE
	else:
		fall_time += delta
		if linear_velocity.y < 0:
			state = State.JUMPING
		elif state != State.SLAMMING:
			state = State.FALLING

func _apply_movement(delta: float) -> void:
	move_input = get_move_input()
	
	if move_input != 0:
		var force_multiplier = 1.0
		if not is_grounded:
			force_multiplier = air_control
				
		var target_velocity = move_input * max_speed
		if state == State.DASHING:
			target_velocity = move_input * dash_force
			force_multiplier = 1.0
			dash_timer.start()
			state = State.IDLE
		var velocity_diff = target_velocity - linear_velocity.x
		var force = velocity_diff * move_force * force_multiplier * delta
		apply_central_force(Vector2(force, 0))
	

func jump() -> void:
	if is_grounded:
		apply_central_impulse(Vector2(0, -jump_force))
		state = State.JUMPING

		if lever:
			var offset = global_position - lever.global_position
			lever.apply_impulse(Vector2.DOWN * jump_force / 2.0, offset)

func start_slam() -> void:
	if not is_grounded and state != State.SLAMMING:
		state = State.SLAMMING
		linear_velocity.y = max_speed * 2.0  # Fast downward velocity


func start_dash() -> void:
	if !dash_timer.is_stopped():
		return
	if (is_grounded or state == State.JUMPING or state == State.FALLING) and state != State.DASHING:
		state = State.DASHING
		

func get_move_input() -> float:
	return 0.0
