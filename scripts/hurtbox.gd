extends Area2D
class_name Hurtbox

signal hit(area: Area2D)

func _ready() -> void:
	self.collision_layer = 3
	self.collision_mask = 3

func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		hit.emit(area)
