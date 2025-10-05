extends Node2D

func _on_back_button_pressed() -> void:
	SceneSwitcher.switch_scene(Scenes.MAIN_MENU_SCENE)
