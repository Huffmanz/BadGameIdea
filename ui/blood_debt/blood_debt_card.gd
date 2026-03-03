extends PanelContainer
class_name BloodDebtCard

signal selected

@onready var name_label: Label = %NameLabel
@onready var description: Label = %Description
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hover_animation_player: AnimationPlayer = $HoverAnimationPlayer

var upgrade: BloodDebtUpgrade
var disabled = false

func _ready() -> void:
	gui_input.connect(on_gui_input)
	mouse_entered.connect(on_mouse_entered)

func play_in(delay: float = 0):
	modulate = Color.TRANSPARENT
	await get_tree().create_timer(delay).timeout
	animation_player.play("in")

func on_gui_input(event: InputEvent):
	if disabled:
		return 
		
	if event.is_action_pressed("left_mouse"):
		select_card()

func set_ability_upgrade(new_upgrade: BloodDebtUpgrade):
	upgrade = new_upgrade
	name_label.text = upgrade.name
	description.text = upgrade.get_description()
	
func select_card():
	disabled = true
	animation_player.play("selected")
	for effect in upgrade.effects:
		if effect and effect is EffectBase:
			effect.apply_effect()
	await animation_player.animation_finished
	selected.emit()
	
func play_discard():
	if disabled:
		return
	animation_player.play("discard")
	
func on_mouse_entered():
	if disabled == true:
		return
	hover_animation_player.play("hover")
