extends Node2D

@onready var camera_2d: Camera2D = $Camera2D

const BUTTON_CLICK = preload("uid://cyn6ax5cersg1")

@onready var label: Label = $CanvasLayer/Control/Label
@onready var buttons: Node2D = $CanvasLayer/Control/Buttons

func _ready() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(label, "position", Vector2.ZERO, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	
	for i in buttons.get_children():
		tween.tween_property(i, "position", Vector2(100, i.position.y), 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func _physics_process(_delta: float) -> void:
	camera_2d.position.x += 1

func _on_play_button_pressed() -> void:
	SoundManager.play_sound_with_random_pitch(BUTTON_CLICK)
	SceneSwitcher.switch_scene(Scenes.HOW_TO_PLAY_SCENE)

func _on_quit_button_pressed() -> void:
	SoundManager.play_sound_with_random_pitch(BUTTON_CLICK)
	get_tree().quit()


func _on_credits_button_pressed() -> void:
	SoundManager.play_sound_with_random_pitch(BUTTON_CLICK)
	SceneSwitcher.switch_scene(Scenes.CREDITS_SCENE)
