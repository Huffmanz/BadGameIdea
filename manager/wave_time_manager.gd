class_name WaveManager
extends Node

signal wave_difficulty_increased(arena_difficulty: int)
const DIFFICULTY_INTERVAL = 5
const END_SCREEN = preload("res://levels/end_screen.tscn")
@onready var timer = $Timer

var wave_difficulty = 0
var current_wave = 0

var wave_time_percent := 0

func _ready():
	timer.timeout.connect(on_timer_timeout)
	GameEvents.wave_start_next.connect(start_wave)
	GameEvents.player_died.connect(_on_player_died)
	start_wave()
	
func _process(delta):
	var next_time_target = timer.wait_time - (wave_difficulty + 1) * DIFFICULTY_INTERVAL
	if timer.time_left <= next_time_target:
		wave_difficulty += 1
		wave_difficulty_increased.emit(wave_difficulty)
		
func start_wave():
	var next_wave_time = timer.wait_time + current_wave * DIFFICULTY_INTERVAL
	next_wave_time -= next_wave_time * wave_time_percent
	timer.wait_time = next_wave_time
	current_wave += 1
	timer.start()
	GameEvents.wave_started.emit(current_wave)
	
func _reduce_next_wave_time(percentage: float):
	wave_time_percent = percentage

func get_time_elapsed():
	return timer.time_left

func _on_wave_start_next():
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	start_wave()
	
	
func on_timer_timeout():
	#ScreenTransition.transition()
	#await ScreenTransition.transitioned_halfway
	wave_time_percent = 0
	GameEvents.wave_complete.emit(current_wave)
	
func _on_player_died():
	timer.stop()
	var instance = END_SCREEN.instantiate()
	get_tree().current_scene.add_child(instance)
	instance.init(current_wave)
