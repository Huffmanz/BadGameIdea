extends Node

@export var basic_enemy_scene: PackedScene
@export var wizard_enemy_scene: PackedScene
@export var archer_enemy_scene: PackedScene
@export var wave_timer_manager:WaveManager
@export var max_enemies: int = 999
@export var spawn_rect: ReferenceRect

@onready var timer = $Timer
var base_spawn_time = 0
var enemy_table = WeightedTable.new()

var enemy_count := 0

var wave_complete := false

func _ready():
	enemy_table.add_item(basic_enemy_scene, 10)
	timer.timeout.connect(on_timer_timeout)
	wave_timer_manager.wave_difficulty_increased.connect(on_wave_difficulty_increased)
	base_spawn_time = timer.wait_time
	GameEvents.wave_complete.connect(_wave_complete)
	GameEvents.wave_started.connect(_wave_started)
	GameEvents.enemy_died.connect(_on_enemy_died)
	
func _wave_complete(wave_number: int):
	wave_complete = true
	timer.wait_time = base_spawn_time
	timer.stop()
	
func _wave_started(wave_number: int):
	timer.start()
	wave_complete = false
	enemy_count = 0

func _on_enemy_died():
	enemy_count -= 1
	if enemy_count <= 0 and wave_complete:
		GameEvents.wave_start_next.emit()

func get_spawn_position():  
	var x = randf_range(0, spawn_rect.size.x)
	var y = randf_range(0, spawn_rect.size.y)
	return spawn_rect.global_position + Vector2(x, y)
			
	
func on_timer_timeout():
	timer.start()

	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	if entities_layer == null:
		return
	
	if entities_layer.get_child_count() - 1 >= max_enemies:
		return
	var enemy_scene = enemy_table.pick_item()
	var enemy = enemy_scene.instantiate() as Node2D
	entities_layer.add_child(enemy)
	enemy_count += 1
	enemy.global_position = get_spawn_position()

func on_wave_difficulty_increased(wave_difficulty: int):
	var time_off = (.1 /12) * wave_difficulty # 12 5 second segments in a minute
	time_off = min(time_off, .8)
	timer.wait_time = base_spawn_time - time_off
	timer.wait_time = max(1, timer.wait_time)
	if wave_difficulty == 4 and wizard_enemy_scene != null:
		enemy_table.add_item(wizard_enemy_scene, 15)
	elif wave_difficulty == 8 and archer_enemy_scene != null:
		enemy_table.add_item(archer_enemy_scene, 10)
