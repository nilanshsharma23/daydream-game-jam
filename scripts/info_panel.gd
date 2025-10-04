extends TextureRect

@onready var label: Label = $Label

func _on_close_button_pressed() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0, 0), 0.25).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_callback(hide)

func show_info_panel(text: String) -> void:
	label.text = text
	show()
	var tween: Tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
