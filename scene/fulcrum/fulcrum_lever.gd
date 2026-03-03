extends RigidBody2D
class_name FulcrumLever

@export var lever_length: float = 400.0
@export var max_rotation_angle: float = 60.0
@export var angular_damping_value: float = 2.0

var fulcrum_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	angular_damp = angular_damping_value
	fulcrum_position = position
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0
	rotation = 0.0

func _physics_process(_delta: float) -> void:
	#_enforce_rotation_limits()
	
	# Dampen small movements to prevent drift
	if abs(angular_velocity) < 0.01:
		angular_velocity = 0.0
	if linear_velocity.length() < 0.1:
		linear_velocity = Vector2.ZERO
	
	# Apply small torque toward neutral position
	var angle = rotation
	if abs(angle) > 0.01:
		var return_torque = -angle * 500.0
		apply_torque(return_torque)

func _enforce_rotation_limits() -> void:
	var angle_deg = rad_to_deg(rotation)
	var max_angle = max_rotation_angle
	
	if abs(angle_deg) > max_angle:
		rotation = deg_to_rad(clamp(angle_deg, -max_angle, max_angle))
		angular_velocity *= 0.5

func apply_torque_from_position(force: float, distance: float) -> void:
	var torque = force * distance
	apply_torque(torque)

func get_lever_angle() -> float:
	return rad_to_deg(rotation)

func get_velocity_at_position(pos: Vector2) -> Vector2:
	var r = pos - global_position
	var tangential_velocity = Vector2(-r.y, r.x) * angular_velocity
	return linear_velocity + tangential_velocity

func get_distance_from_fulcrum(pos: Vector2) -> float:
	var to_pos = pos - global_position
	var lever_right = Vector2.RIGHT.rotated(rotation)
	return to_pos.dot(lever_right)
