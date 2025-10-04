extends TextureRect

@onready var label: Label = $Label

func _on_close_button_pressed() -> void:
	hide()

func show_info_panel(text: String) -> void:
	print("here")
	show()
	label.text = text
