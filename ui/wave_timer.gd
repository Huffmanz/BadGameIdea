extends CanvasLayer

@export var wave_time_manager: Node
@onready var label = %WaveTimeLabel
@onready var wave_number_label: Label = %WaveNumberLabel

func _ready() -> void:
	GameEvents.wave_started.connect(_wave_started)
	GameEvents.wave_complete.connect(_wave_complete)

func _process(delta):
	if wave_time_manager == null:
		return
	var time_elapsed = wave_time_manager.get_time_elapsed()
	label.text = format_seconds_to_string(time_elapsed)

func format_seconds_to_string(seconds: float):
	var minutes : int = floor(seconds / 60)
	var remaining_seconds = seconds - (minutes * 60)
	return str(minutes) + ":" + ("%02d" % floor(remaining_seconds))
	
func _wave_started(wave_number:int):
	visible = true
	wave_number_label.text = str(wave_number)

func _wave_complete(wave_number: int):
	visible = false
