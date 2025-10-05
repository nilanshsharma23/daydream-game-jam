extends Area2D
class_name Hitbox

func _ready() -> void:
	self.collision_layer = 3
	self.collision_mask = 3

@export var damage: int
