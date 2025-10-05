extends Area2D
@export var next_level: PackedScene

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		SceneSwitcher.switch_scene(next_level)
