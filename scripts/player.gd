extends CharacterBody2D

const GRAVITY: float = 400.0
const WALK_SPEED: float = 200.0
const JUMP_SPEED: float = 200

var is_touching_ground: bool = false

@export var body_parts: Array[Sprite2D]

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var limbs: Node2D = $Limbs

func _physics_process(delta: float) -> void:
	velocity.y += delta * GRAVITY
	
	if Input.is_action_pressed("move_left"):
		velocity.x = -WALK_SPEED
		
		for sprite in body_parts:
			sprite.flip_h = true
		
		animation_player.play("walk")
		limbs.scale.x = -1
	elif Input.is_action_pressed("move_right"):
		velocity.x = WALK_SPEED
		
		for sprite in body_parts:
			sprite.flip_h = false
		
		animation_player.play("walk")
		limbs.scale.x = 1
	else:
		velocity.x = 0
		
		animation_player.play("idle")
	
	if Input.is_action_just_pressed("jump"):
		velocity.y -= JUMP_SPEED
	
	move_and_slide()

func _on_ground_detector_body_entered(body: Node2D) -> void:
	print("entered")
	print(body.name)

func _on_ground_detector_body_exited(body: Node2D) -> void:
	print("exited")
	print(body.name)
