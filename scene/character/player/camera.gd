extends Camera2D

@export var random_strength: float = 30.0
@export var shakeFade: float = 5.0

var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0

func _ready():
	GameEvents.camera_shake.connect(apply_shake)

func _process(delta):
	var SCREEN_CENTER = get_viewport_rect().size / 2
	global_position = SCREEN_CENTER
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shakeFade * delta)
		offset = randomOffset()
		print("Shaking camera: ", offset)
		
func apply_shake(camera_shake_strength: float):
	shake_strength = camera_shake_strength
	
func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength),rng.randf_range(-shake_strength, shake_strength))
	
