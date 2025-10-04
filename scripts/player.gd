extends CharacterBody2D

const GRAVITY: float = 200.0
const WALK_SPEED: float = 400.0

func _physics_process(delta: float) -> void:
	velocity.y += delta * GRAVITY
	
	if Input.is_action_pressed("move_left"):
		velocity.x = -WALK_SPEED
	elif Input.is_action_pressed("move_right"):
		velocity.x = WALK_SPEED
	else:
		velocity.x = 0
	
	move_and_slide()
