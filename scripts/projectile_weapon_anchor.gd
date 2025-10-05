extends Node2D
class_name ProjectileWeaponAnchor

@onready var projectile_instantiation_marker: Marker2D = $ProjectileInstantiationMarker
@onready var delay_timer: Timer = $DelayTimer
@onready var projectile_weapon: Sprite2D = $ProjectileWeapon

const SHOOT: AudioStream = preload("uid://dm36rawvf4vnj")

var projectile_scene: PackedScene

func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	projectile_instantiation_marker.look_at(get_global_mouse_position())

func shoot() -> void:
	if not delay_timer.is_stopped():
		return
	
	var projectile: Projectile = projectile_scene.instantiate()
	get_tree().root.add_child(projectile)
	
	projectile.global_position = projectile_weapon.global_position
	projectile.global_rotation = projectile_weapon.global_rotation
	
	var tween = get_tree().create_tween()
	tween.tween_property(projectile_weapon, "scale", Vector2(0.65, 0.85), 0.05).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(projectile_weapon, "scale", Vector2(0.75, 0.75), 0.05).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	
	SoundManager.play_sound_with_random_pitch(SHOOT)
	CameraShake.shake(1, 0.1)
	
	delay_timer.start()
