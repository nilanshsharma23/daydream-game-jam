extends CharacterBody2D

const GRAVITY: float = 400.0
const SPEED: float = 80.0
var direction: int = 1  # 1 = right, -1 = left

@onready var sprite: Sprite2D = $Sprite2D

#func _ready() -> void:
	#patrol_timer.timeout.connect(_on_patrol_timer_timeout)
	#patrol_timer.start()

func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta
	velocity.x = SPEED * direction
	move_and_slide()

	sprite.flip_h = direction < 0

#func _on_patrol_timer_timeout() -> void:
	#direction *= -1
