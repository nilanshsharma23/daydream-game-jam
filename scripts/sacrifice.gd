extends Resource
class_name Sacrifice

enum WeaponType {
	MELEE,
	PROJECTILE,
	NONE
}

@export var name: String
@export var health_decrease: int
@export var jump_boost: int
@export var speed_boost: int
@export_multiline var sacrifice_description: String
@export var weapon_type: WeaponType = WeaponType.NONE
@export var damage: int

@export_category("Melee Weapon Properties")
@export var melee_weapon_sprite: Texture2D

@export_category("Projectile Weapon Properties")
@export var projectile_weapon_sprite: Texture2D
@export var projectile: PackedScene
