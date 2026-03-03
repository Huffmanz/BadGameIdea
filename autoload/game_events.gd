extends Node

#player
signal camera_shake(camera_shake_strength: float)
signal player_health_updated(current_health: float)
signal player_died()

#wave management
signal wave_started(wave_number: int)
signal wave_complete(wave_number: int)
signal wave_start_next()


func emit_camera_shake(camera_shake_strength: float) -> void:
	camera_shake.emit(camera_shake_strength)
	
func emit_player_health_updated(amount: float):
	player_health_updated.emit(amount)
