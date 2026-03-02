extends Node
class_name LeverAffector

@export var mass: float = 50.0
@export var jump_impulse: float = 600.0
@export var slam_impulse_multiplier: float = 3.0
@export var slide_acceleration: float = 200.0
@export var launch_angular_velocity_threshold: float = 2.0
@export var snap_strength: float = 0.2

var is_on_lever: bool = false
var current_lever: FulcrumLever = null
var current_surface: LeverSurface = null
var character: RigidBody2D

signal launched

func _ready() -> void:
	character = get_parent() as RigidBody2D
	if not character:
		push_error("LeverAffector must be a child of RigidBody2D")

func _physics_process(delta: float) -> void:
	if is_on_lever and current_lever:
		apply_continuous_torque()
		check_and_apply_sliding(delta)
		snap_to_lever_surface()
		check_launch_conditions()

func attach_to_lever(lever: FulcrumLever, surface: LeverSurface) -> void:
	# Prevent re-attaching if already attached
	if is_on_lever and current_lever == lever:
		return
	
	current_lever = lever
	current_surface = surface
	is_on_lever = true
	
	if character and character.has_method("_on_landed"):
		character._on_landed()

func detach_from_lever() -> void:
	is_on_lever = false
	current_lever = null
	current_surface = null

func apply_continuous_torque() -> void:
	if not is_on_lever or not current_lever:
		return
	
	var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	var distance = current_lever.get_distance_from_fulcrum(character.global_position)
	var lever_angle = deg_to_rad(current_lever.get_lever_angle())
	
	var torque = mass * gravity * distance * cos(lever_angle)
	current_lever.apply_torque(torque/100000.0)

func apply_jump_impulse() -> void:
	if not is_on_lever or not current_lever:
		return
	
	var distance = current_lever.get_distance_from_fulcrum(character.global_position)
	var counter_torque = -jump_impulse * mass * distance * 0.1
	current_lever.apply_torque_impulse(counter_torque)

func apply_slam_impulse() -> void:
	if not is_on_lever or not current_lever:
		return
	
	var slam_force = mass * slam_impulse_multiplier * 100.0
	var distance = current_lever.get_distance_from_fulcrum(character.global_position)
	current_lever.apply_torque_impulse(slam_force * distance)

func check_and_apply_sliding(delta: float) -> void:
	if not current_surface:
		return
	
	var angle = abs(current_lever.get_lever_angle())
	if angle > current_surface.slide_angle_threshold:
		var slide_direction = sign(current_lever.rotation)
		var slide_force = (angle - current_surface.slide_angle_threshold) * slide_acceleration
		character.apply_central_force(Vector2(slide_direction * slide_force, 0))

func check_launch_conditions() -> void:
	if not is_on_lever:
		return
	
	var angular_vel = current_lever.angular_velocity
	var distance = current_lever.get_distance_from_fulcrum(character.global_position)
	
	if sign(distance) != sign(angular_vel) and abs(angular_vel) > launch_angular_velocity_threshold:
		var launch_vel = current_lever.get_velocity_at_position(character.global_position)
		character.linear_velocity = launch_vel
		detach_from_lever()
		launched.emit()

func snap_to_lever_surface() -> void:
	if not is_on_lever or not current_lever or not current_surface:
		return
	
	var lever_pos = current_lever.global_position
	var to_char = character.global_position - lever_pos
	var lever_right = Vector2.RIGHT.rotated(current_lever.rotation)
	var distance_along = to_char.dot(lever_right)
	
	# Clamp to lever bounds
	distance_along = clamp(distance_along, -current_lever.lever_length, current_lever.lever_length)
	
	var surface_normal = current_surface.get_surface_normal()
	var target_pos = lever_pos + lever_right * distance_along + surface_normal * current_surface.surface_offset
	
	# Use force-based snapping for RigidBody2D
	var offset = target_pos - character.global_position
	var distance_to_target = offset.length()
	
	if distance_to_target > 0.5:
		# Apply force toward target position
		var snap_force = offset.normalized() * distance_to_target * 1000.0 * snap_strength
		character.apply_central_force(snap_force)
		
		# Dampen velocity perpendicular to lever surface for stability
		var tangent = lever_right
		var perpendicular_vel = character.linear_velocity.dot(surface_normal)
		if abs(perpendicular_vel) > 10:
			character.linear_velocity -= surface_normal * perpendicular_vel * 0.5
