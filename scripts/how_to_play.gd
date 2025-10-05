extends Node2D

@onready var camera_2d: Camera2D = $Camera2D

const BUTTON_CLICK = preload("uid://cyn6ax5cersg1")
const SONG_21 = preload("uid://c5ort5favvekm")

func _physics_process(_delta: float) -> void:
	camera_2d.position.x += 1

func _on_proceed_button_pressed() -> void:
	SoundManager.play_sound_with_random_pitch(BUTTON_CLICK)
	SoundManager.stop_music()
	SoundManager.play_music(SONG_21)
	SceneSwitcher.switch_scene(Scenes.LEVEL_1_SCENE)
