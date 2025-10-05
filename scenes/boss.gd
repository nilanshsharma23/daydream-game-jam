extends Enemy

@onready var health_bar: TextureProgressBar = $CanvasLayer/Control/HealthBar
@onready var label: Label = $CanvasLayer/Control/HealthBar/Label

func _on_health_changed(new_health: int) -> void:
	health_bar.value = new_health
	label.text = "%s / 200" % new_health
