extends Node2D
class_name MeleeWeaponAnchor

@export var weapon_offset: Vector2
@export var swing_speed: float = 10

@onready var melee_weapon_sprite: Sprite2D = $MeleeWeaponSprite

var swing: int = -1
var target: float
var swing_angle: float
var swinging: bool
var pos_to_point_at: Vector2

var angle: float
var damage: int

func _process(delta: float) -> void:
	angle = rad_to_deg(atan2(pos_to_point_at.y, pos_to_point_at.x))
	swing_angle = lerp(swing_angle, float(swing) * 90, delta * swing_speed)
	rotation_degrees = angle + swing_angle
	
	var t: float = 240 if swing == 1 else -30
	target = lerp(target, t, delta * swing_speed)
	
	if abs(t - target) < 5:
		swinging = false
	
	melee_weapon_sprite.rotation_degrees = target

func swing_weapon() -> void:
	if swinging:
		return
	
	swing *= -1
	swinging = true
