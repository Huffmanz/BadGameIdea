extends Area2D

func _ready() -> void:
    body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
    if body is Enemy:
        GameEvents.enemy_died.emit()
    if body is Player:
        GameEvents.player_died.emit()
    body.queue_free()