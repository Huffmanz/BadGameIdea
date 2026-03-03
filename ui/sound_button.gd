extends Button

@onready var random_stream_player: AudioStreamPlayer2D = $RandomStreamPlayer
@onready var blood_debt_shaker: Shaker = %BloodDebtShaker

func _ready():
	pressed.connect(on_pressed)
	mouse_entered.connect(on_mouse_entered)
	
func on_pressed():
	random_stream_player.play_random()
	blood_debt_shaker.start(.25)

func on_mouse_entered():
	random_stream_player.play_random()
	blood_debt_shaker.start(.25)
