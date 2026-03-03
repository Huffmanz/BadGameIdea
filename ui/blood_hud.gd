class_name BloodHud
extends CanvasLayer

@onready var blood_text: Label = %BloodText
@onready var blood_description: Label = %BloodDescripttion
@onready var blood_debt_text: Label = %BloodDebtText
@onready var blood_debt_description: Label = %BloodDebtDescription


func _ready() -> void:
	GameEvents.player_health_updated.connect(_player_health_updated)
	GameEvents.blood_debt_updated.connect(update_blood_debt_text)
	GameEvents.wave_started.connect(_wave_started)
	GameEvents.wave_complete.connect(_wave_complete)
	
	
func change_visibility_blood(visibility: bool):
	if visibility:
		blood_text.self_modulate.a = 1
		blood_description.self_modulate.a = 1
	else:
		blood_text.self_modulate.a = 0
		blood_description.self_modulate.a = 0
	
func change_visibility_debt(visibility: bool):
	if visibility:
		blood_debt_text.self_modulate.a = 1
		blood_debt_description.self_modulate.a = 1
	else:
		blood_debt_text.self_modulate.a = 0
		blood_debt_description.self_modulate.a = 0
	
func _player_health_updated(amount: int) -> void:
	update_blood_text(amount)
	
func update_blood_text(amount: int) -> void:
	blood_text.text = str(amount)
	
func update_blood_debt_text(amount: int) -> void:
	blood_debt_text.text = str(amount)
	
func _wave_started(wave_number: int):
	visible = true
	
func _wave_complete(wave_number: int):
	visible = false
	
