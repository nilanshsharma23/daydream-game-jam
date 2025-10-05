extends Node2D

@onready var camera_2d: Camera2D = $Camera2D
const BUTTON_CLICK = preload("uid://cyn6ax5cersg1")

func _physics_process(_delta: float) -> void:
	camera_2d.position.x += 1

func _on_back_button_pressed() -> void:
	SoundManager.play_sound_with_random_pitch(BUTTON_CLICK)
	SceneSwitcher.switch_scene(Scenes.MAIN_MENU_SCENE)
