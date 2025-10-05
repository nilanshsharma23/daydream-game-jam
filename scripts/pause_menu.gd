extends TextureRect

@onready var pause_panel: Control = $".."

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	SceneSwitcher.switch_scene(Scenes.MAIN_MENU_SCENE)

func _on_resume_button_pressed() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", Vector2(352, -524), 0.25).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_callback(pause_panel.hide)
	tween.tween_callback(resume_game)

func resume_game() -> void:
	get_tree().paused = false
