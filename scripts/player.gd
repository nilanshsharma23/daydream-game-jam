extends CharacterBody2D

const GRAVITY: float = 400.0
var walk_speed: float = 100
const JUMP_SPEED: float = 150

var is_touching_ground: bool = false
var filled: bool = false

var max_health: int = 100
var health: int = 100

@export var body_parts: Array[Sprite2D]
@export var body_part_dictionary: Dictionary[Sprite2D, CheckBox]
@export var sacrifices: Array[Sacrifice]

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var limbs: Node2D = $Limbs
@onready var strength_meter: TextureProgressBar = $CanvasLayer/Control/VBoxContainer/StrengthMeter
@onready var slash_sprite: Sprite2D = $SlashSprite
@onready var sacrifices_panel: Control = $CanvasLayer/SacrificesPanel
@onready var health_meter: TextureProgressBar = $CanvasLayer/Control/VBoxContainer/HealthMeter
@onready var info_panel: TextureRect = $CanvasLayer/InfoControl/InfoPanel

func _ready() -> void:
	slash_sprite.visible = false
	
	health_meter.get_child(0).text = "%s/%s" % [health, max_health]
	
	for i in len(body_part_dictionary.values()):
		var button: TextureButton = body_part_dictionary.values()[i].get_parent().get_child(1)
		
		button.pressed.connect(info_panel.show_info_panel.bind(sacrifices[i].sacrifice_description))

func _process(_delta: float) -> void:
	if Input.is_action_pressed("fill_meter"):
		strength_meter.value += 1
	
	if velocity.x != 0 and is_touching_ground:
		if walk_speed >= 200:
			animation_player.play("sprint")
		else:
			animation_player.play("walk")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		animation_player.play("slash")
	
	if event.is_action_pressed("jump") and is_touching_ground:
		velocity.y -= JUMP_SPEED

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
		
		slash_sprite.flip_h = true
		
		limbs.scale.x = -1
	elif Input.is_action_pressed("move_right"):
		velocity.x = walk_speed
		
		for sprite in body_parts:
			sprite.flip_h = false
		
		slash_sprite.flip_h = false
		
		limbs.scale.x = 1
	else:
		velocity.x = 0
	
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

func _on_hurtbox_hit() -> void:
	print("hit")

func _on_sacrifices_button_pressed() -> void:
	var tween: Tween = create_tween()
	
	if sacrifices_panel.visible:
		tween.tween_property(sacrifices_panel, "position", Vector2(0, -720), 0.25).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
		tween.tween_callback(sacrifices_panel.hide)
	else:
		sacrifices_panel.show()
		tween.tween_property(sacrifices_panel, "position", Vector2(0, 0), 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
