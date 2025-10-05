extends Node2D

@onready var camera_2d: Camera2D = $Camera2D

func _physics_process(_delta: float) -> void:
	camera_2d.position.x += 1

func _on_play_button_pressed() -> void:
	SceneSwitcher.switch_scene(Scenes.HOW_TO_PLAY_SCENE)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
