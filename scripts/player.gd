extends CharacterBody2D

const GRAVITY: float = 400.0
var walk_speed: float = 100.0
var jump_speed: float = 150.0

var is_touching_ground: bool = false
var filled: bool = false

var max_health: int = 100
var health: int = 100

# 🦊 Coyote Time
var coyote_time: float = 0.2
var coyote_timer: float = 0.0

@export var body_parts: Array[Sprite2D]
@export var body_part_dictionary: Dictionary
@export var sacrifices: Array

@onready var vignette: ColorRect = $CanvasLayer/Control/Vignette
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var limbs: Node2D = $Limbs
@onready var strength_meter: TextureProgressBar = $CanvasLayer/Control/VBoxContainer/StrengthMeter
@onready var slash_sprite: Sprite2D = $SlashSprite
@onready var sacrifices_panel: Control = $CanvasLayer/SacrificesPanel
@onready var health_meter: TextureProgressBar = $CanvasLayer/Control/VBoxContainer/HealthMeter
@onready var info_panel: TextureRect = $CanvasLayer/InfoControl/InfoPanel
@onready var vignette_player: AnimationPlayer = $VignettePlayer

func _ready() -> void:
	slash_sprite.visible = false
<<<<<<< Updated upstream
	var label = health_meter.get_node("Label") as Label
	label.text = "%s/%s" % [health, max_health]

	for i in body_part_dictionary.size():
		var checkbox = body_part_dictionary.values()[i] as CheckBox
		var info_button = checkbox.get_parent().get_node("InfoButton") as TextureButton
=======
	health_meter.get_child(0).text = "%s/%s" % [health, max_health]

	for i in len(body_part_dictionary.values()):
		var checkbox := body_part_dictionary.values()[i]
		var info_button: TextureButton = checkbox.get_parent().get_child(1)
>>>>>>> Stashed changes
		info_button.pressed.connect(info_panel.show_info_panel.bind(sacrifices[i].sacrifice_description))
		checkbox.toggled.connect(make_sacrifice.bind(sacrifices[i], i))

func _process(_delta: float) -> void:
	if Input.is_action_pressed("fill_meter"):
		strength_meter.value += 1

	if velocity.x != 0.0 and is_touching_ground:
		animation_player.play("sprint" if walk_speed >= 200.0 else "walk")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		animation_player.play("slash")

	# 🦘 Jump with coyote time
	if event.is_action_pressed("jump") and coyote_timer > 0.0:
		velocity.y = -jump_speed
		coyote_timer = 0.0

func _physics_process(delta: float) -> void:
	# Gravity
	velocity.y += delta * GRAVITY

	# Coyote time update
	coyote_timer = coyote_time if is_touching_ground else coyote_timer - delta

	# Movement
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
		velocity.x = 0.0

	# 🪂 Dynamic jump height
	if Input.is_action_just_released("jump") and velocity.y < 0.0:
		velocity.y *= 0.5

	if filled:
		print("filled")

	move_and_slide()

func _on_ground_detector_body_entered(_body: Node2D) -> void:
	is_touching_ground = true
	coyote_timer = coyote_time

func _on_ground_detector_body_exited(_body: Node2D) -> void:
	is_touching_ground = false

func _on_strength_meter_value_changed(value: float) -> void:
	filled = value == 100.0

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

<<<<<<< Updated upstream
func make_sacrifice(toggled_on: bool, sacrifice, index: int) -> void:
	var body_part = body_part_dictionary.keys()[index] as Sprite2D
=======
func make_sacrifice(toggled_on: bool, sacrifice: Sacrifice, index: int) -> void:
	var body_part := body_part_dictionary.keys()[index]
>>>>>>> Stashed changes
	if toggled_on:
		body_part.hide()
		max_health -= sacrifice.health_decrease
		jump_speed += sacrifice.jump_boost
		walk_speed += sacrifice.speed_boost
		if index == 0:
			vignette_player.play("show")
	else:
		body_part.show()
		max_health += sacrifice.health_decrease
		jump_speed -= sacrifice.jump_boost
		walk_speed -= sacrifice.speed_boost
		if index == 0:
			vignette_player.play("hide")

<<<<<<< Updated upstream
	var label = health_meter.get_node("Label") as Label
	label.text = "%s/%s" % [health, max_health]
=======
	health_meter.get_child(0).text = "%s/%s" % [health, max_health]
>>>>>>> Stashed changes
	health_meter.max_value = max_health
