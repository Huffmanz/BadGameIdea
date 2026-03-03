extends CanvasLayer

signal transitioned_halfway

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var skip_emit = false

func transition():
	animation_player.play("default")
	await transitioned_halfway
	skip_emit = true
	animation_player.play_backwards("default")
	await animation_player.animation_finished
	skip_emit = false
	
func emit_transition_halfway():
	if skip_emit: 
		skip_emit = false
		return
	transitioned_halfway.emit()

func transition_to_scene(scene_path: String):
	transition()
	await transitioned_halfway
	get_tree().paused = false
	get_tree().change_scene_to_file(scene_path)
