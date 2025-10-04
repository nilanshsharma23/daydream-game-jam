extends Area2D
class_name Hurtbox

signal hit

func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox and area.get_parent() != get_parent():
		hit.emit()
