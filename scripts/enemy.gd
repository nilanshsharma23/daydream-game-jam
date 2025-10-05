extends CharacterBody2D

const GRAVITY: float = 400.0
const SPEED: float = 50.0
var direction: int = 1  # 1 = right, -1 = left

var knockback: Vector2
var knockback_tween: Tween

var player_detected: bool

const HURT = preload("uid://dej72cqyem30i")

@export var health: int = 100

@onready var player_ray: RayCast2D = $PlayerRay
@onready var sprite: Sprite2D = $Sprite2D
@onready var hit_timer: Timer = $HitTimer

func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta
	
	if player_detected:
		velocity.x = SPEED * global_position.direction_to(PlayerManager.player_position).x + knockback.x
	else:
		velocity.x = SPEED * direction + knockback.x
	
	move_and_slide()

	sprite.flip_h = velocity.x < 0

func _on_patrol_timer_timeout() -> void:
	direction *= -1

func _on_hurtbox_hit(area: Area2D) -> void:
	if area is PlayerHitbox:
		health -= area.damage
		sprite.material.set_shader_parameter("flashing", true)
		hit_timer.start()
		receive_knockback(area.global_position, area.damage, Vector2(25, 25))
		HitStop.hit_stop(0, 0.25)
		SoundManager.play_sound_with_random_pitch(HURT)
		CameraShake.shake(1, 0.1)
		print(area.get_parent().name)
		if area.get_parent() is Projectile:
			area.get_parent().queue_free()

func _on_hit_timer_timeout() -> void:
		sprite.material.set_shader_parameter("flashing", false)

func receive_knockback(damage_source_pos: Vector2, recieved_damage: int, knockback_strength: Vector2 = Vector2(0, 0), stop_time: float = 0.25) -> void:
	var knockback_direction: Vector2 = damage_source_pos.direction_to(global_position)
	
	knockback = knockback_strength * knockback_direction * recieved_damage
	
	if knockback_tween:
		knockback_tween.kill()
	
	knockback_tween = get_tree().create_tween()
	knockback_tween.parallel().tween_property(self, "knockback", Vector2(0, 0), stop_time)

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player_detected = true
