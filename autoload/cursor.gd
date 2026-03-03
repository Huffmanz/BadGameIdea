extends Sprite2D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	GameEvents.wave_started.connect(_on_wave_started)
	GameEvents.wave_complete.connect(_on_wave_complete)
	GameEvents.player_died.connect(_on_player_died)
	
func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
	visible = !get_tree().paused
	if visible:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func _on_wave_started(wave_number: int) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	visible = true
	
func _on_wave_complete(wave_number: int) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	visible = false
	
func _on_player_died():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	visible = false
	
