extends Area2D
class_name RespawnArea

@export var respawn_point: Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player: Player = $"../Player"

func _on_body_entered(body: Node2D) -> void:
	if body is Player: respawn()

func respawn() -> void:
	animation_player.play("hide")
	player.global_position = respawn_point.global_position
	animation_player.play("show")
