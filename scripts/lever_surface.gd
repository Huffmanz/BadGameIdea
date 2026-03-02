extends Area2D
class_name LeverSurface

@export var surface_friction: float = 0.8
@export var slide_angle_threshold: float = 25.0
@export var surface_offset: float = 20.0

var active_affectors: Array[Node] = []
var fulcrum_lever: FulcrumLever

func _ready() -> void:
	fulcrum_lever = get_parent() as FulcrumLever
	if not fulcrum_lever:
		push_error("LeverSurface must be a child of FulcrumLever")
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.has_node("LeverAffector"):
		var affector = body.get_node("LeverAffector")
		if affector and not active_affectors.has(affector):
			active_affectors.append(affector)
			affector.attach_to_lever(fulcrum_lever, self)

func _on_body_exited(body: Node2D) -> void:
	if body.has_node("LeverAffector"):
		var affector = body.get_node("LeverAffector")
		if affector and active_affectors.has(affector):
			if affector.current_lever == fulcrum_lever:
				affector.detach_from_lever()
			active_affectors.erase(affector)

func get_surface_normal() -> Vector2:
	return Vector2.UP.rotated(fulcrum_lever.rotation)

func get_distance_from_fulcrum(pos: Vector2) -> float:
	return fulcrum_lever.get_distance_from_fulcrum(pos)

func has_active_affectors() -> bool:
	return active_affectors.size() > 0
