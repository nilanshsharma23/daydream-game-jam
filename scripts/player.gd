extends CharacterBody2D

const GRAVITY: float = 400.0
var walk_speed: float = 100
const JUMP_SPEED: float = 200

var is_touching_ground: bool = false
var filled: bool = false

@export var body_parts: Array[Sprite2D]

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var limbs: Node2D = $Limbs
@onready var strength_meter: TextureProgressBar = $CanvasLayer/Control/StrengthMeter

func _process(_delta: float) -> void:
	if Input.is_action_pressed("fill_meter"):
		strength_meter.value += 1

func _physics_process(delta: float) -> void:
	velocity.y += delta * GRAVITY
	
	if Input.is_action_pressed("sprint"):
		walk_speed = 200
	else:
		walk_speed = 100
	
	if Input.is_action_pressed("move_left"):
		velocity.x = -walk_speed
		
		for sprite in body_parts:
			sprite.flip_h = true
		
		if walk_speed >= 200:
			animation_player.play("sprint")
		else:
			animation_player.play("walk")
			
		limbs.scale.x = -1
	elif Input.is_action_pressed("move_right"):
		velocity.x = walk_speed
		
		for sprite in body_parts:
			sprite.flip_h = false
		
		if walk_speed >= 200:
			animation_player.play("sprint")
		else:
			animation_player.play("walk")
		
		limbs.scale.x = 1
	else:
		velocity.x = 0
		
		animation_player.play("idle")
	
	if Input.is_action_just_pressed("jump") and is_touching_ground:
		velocity.y -= JUMP_SPEED
	
	if filled:
		print("filled")
	
	move_and_slide()

func _on_ground_detector_body_entered(_body: Node2D) -> void:
	is_touching_ground = true

func _on_ground_detector_body_exited(_body: Node2D) -> void:
	is_touching_ground = false

func _on_strength_meter_value_changed(value: float) -> void:
	if value == 100:
		filled = true
	else:
		filled = false
