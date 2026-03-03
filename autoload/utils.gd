extends Node

var floating_text_scene = preload("res://ui/floating_text.tscn")
var player_ref:Player

func frameFreeze(timeScale, duration):
	Engine.time_scale = timeScale
	await get_tree().create_timer(duration * timeScale).timeout
	Engine.time_scale = 1.0
	
func create_negative_numbers(global_position: Vector2, damage: float):
	var floating_text = floating_text_scene.instantiate() as Node2D
	get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text)
	floating_text.global_position = global_position + (Vector2.UP * 16)
	var format_screen = "-%0.0f"
	floating_text.start(format_screen % damage)
	
func create_positive_numbers(global_position: Vector2, damage: float):
	var floating_text = floating_text_scene.instantiate() as Node2D
	get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text)
	floating_text.global_position = global_position + (Vector2.UP * 16)
	var format_screen = "+%0.0f"
	floating_text.start(format_screen % damage)
	
func get_player() -> Player:
	if not player_ref || !is_instance_valid(player_ref):
		player_ref = get_tree().get_first_node_in_group("player") as Player
	return player_ref
	
