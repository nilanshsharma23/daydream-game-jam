extends Enemy

@onready var health_bar: TextureProgressBar = $CanvasLayer/Control/HealthBar
@onready var label: Label = $CanvasLayer/Control/HealthBar/Label

func _on_health_changed(new_health: int) -> void:
	health_bar.value = new_health
	label.text = "%s / 200" % new_health
	
	if new_health <= 0:
		SceneSwitcher.switch_scene(Scenes.GAME_OVER_SCENE)
