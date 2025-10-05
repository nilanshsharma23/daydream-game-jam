extends Node2D

@onready var camera_2d: Camera2D = $Camera2D

func _physics_process(_delta: float) -> void:
	camera_2d.position.x += 1

func _on_proceed_button_pressed() -> void:
	SceneSwitcher.switch_scene(Scenes.LEVEL_1_SCENE)
