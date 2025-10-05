extends Resource
class_name Sacrifice

enum WeaponType {
	MELEE,
	PROJECTILE
}

@export var name: String
@export var health_decrease: int
@export var jump_boost: int
@export var speed_boost: int
@export_multiline var sacrifice_description: String
@export var weapon_type: WeaponType
