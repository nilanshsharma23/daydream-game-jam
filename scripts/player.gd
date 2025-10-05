extends CharacterBody2D
class_name Player

const GRAVITY: float = 400.0
var walk_speed: float = 100.0
var jump_speed: float = 150.0

var is_touching_ground: bool = false

var max_health: int = 100
var health: int = 100

var no_of_sacrifices: int = 0

# Coyote Time
var coyote_time: float = 0.2
var coyote_timer: float = 0.0

var checkboxes: Array[HBoxContainer]

const SACRIFICE_CHECKBOX = preload("uid://dt4ne3fhxgr4g")

var knockback: Vector2
var knockback_tween: Tween

@export var body_parts: Array[Sprite2D]
@export var sacrificable_body_parts: Array[Sprite2D]
@export var sacrifices: Array[Sacrifice]

@onready var melee_weapon_anchor: MeleeWeaponAnchor = $MeleeWeaponAnchor
@onready var vignette: ColorRect = $CanvasLayer/Control/Vignette
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var limbs: Node2D = $Limbs
@onready var sacrifices_panel: Control = $CanvasLayer/SacrificesPanel
@onready var health_meter: TextureProgressBar = $CanvasLayer/Control/VBoxContainer/HealthMeter
@onready var info_panel: InfoPanel = $CanvasLayer/InfoControl/InfoPanel
@onready var vignette_player: AnimationPlayer = $VignettePlayer
@onready var sacrifice_checkbox_container: VBoxContainer = $CanvasLayer/SacrificesPanel/TextureRect/SacrificeCheckboxContainer
@onready var projectile_weapon_anchor: ProjectileWeaponAnchor = $ProjectileWeaponAnchor
@onready var pause_panel: Control = $CanvasLayer/PausePanel

func _ready() -> void:
	CameraShake.camera = $Camera2D
	var label = health_meter.get_node("Label") as Label
	label.text = "%s/%s" % [health, max_health]
	
	vignette_player.play("hide")
	
	for i in len(sacrificable_body_parts):
		var sacrifice_checkbox: HBoxContainer = SACRIFICE_CHECKBOX.instantiate()
		sacrifice_checkbox.get_child(0).text = sacrifices[i].name
		sacrifice_checkbox.get_child(0).toggled.connect(make_sacrifice.bind(sacrifices[i], i))
		sacrifice_checkbox.get_child(1).pressed.connect(info_panel.show_info_panel.bind(sacrifices[i].sacrifice_description))
		sacrifice_checkbox_container.add_child(sacrifice_checkbox)
		checkboxes.append(sacrifice_checkbox)

func _process(_delta: float) -> void:
	melee_weapon_anchor.pos_to_point_at = (get_local_mouse_position() - melee_weapon_anchor.position).normalized()
	
	PlayerManager.player_position = global_position
	
	if velocity.x != 0.0 and is_touching_ground:
		animation_player.play("sprint" if walk_speed >= 200.0 else "walk")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		if melee_weapon_anchor.visible:
			melee_weapon_anchor.swing_weapon()
		
		if projectile_weapon_anchor.visible:
			projectile_weapon_anchor.shoot()

	# Jump with coyote time
	if event.is_action_pressed("jump") and coyote_timer > 0.0:
		velocity.y = -jump_speed
		coyote_timer = 0.0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("open_menu"):
		var tween: Tween = create_tween()
		if sacrifices_panel.visible:
			tween.tween_property(sacrifices_panel, "position", Vector2(0, -720), 0.25).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
			tween.tween_callback(sacrifices_panel.hide)
		else:
			sacrifices_panel.show()
			tween.tween_property(sacrifices_panel, "position", Vector2(0, 0), 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)


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
		limbs.scale.x = -1
	elif Input.is_action_pressed("move_right"):
		velocity.x = walk_speed
		for sprite in body_parts:
			sprite.flip_h = false
		limbs.scale.x = 1
	else:
		velocity.x = 0.0

	# 🪂 Dynamic jump height
	if Input.is_action_just_released("jump") and velocity.y < 0.0:
		velocity.y *= 0.5
	
	velocity.x += knockback.x

	move_and_slide()

func _on_ground_detector_body_entered(_body: Node2D) -> void:
	is_touching_ground = true
	coyote_timer = coyote_time

func _on_ground_detector_body_exited(_body: Node2D) -> void:
	is_touching_ground = false

func make_sacrifice(toggled_on: bool, sacrifice: Sacrifice, index: int) -> void:
	var body_part: Sprite2D = sacrificable_body_parts[index]
	if toggled_on:
		if no_of_sacrifices >= 2:
			info_panel.show_info_panel("Sacrifice Limit Reached")
			checkboxes[index].get_child(0).button_pressed = false
			return
		
		if (melee_weapon_anchor.visible or projectile_weapon_anchor.visible) and sacrifice.weapon_type != Sacrifice.WeaponType.NONE:
			info_panel.show_info_panel("You already have a weapon")
			checkboxes[index].get_child(0).button_pressed = false
			return
		
		body_part.hide()
		max_health -= sacrifice.health_decrease
		health -= sacrifice.health_decrease
		jump_speed += sacrifice.jump_boost
		no_of_sacrifices += 1
		
		if sacrifice.weapon_type == Sacrifice.WeaponType.MELEE:
			melee_weapon_anchor.get_child(0).get_child(0).damage = sacrifice.damage
			melee_weapon_anchor.get_child(0).texture = sacrifice.melee_weapon_sprite
			melee_weapon_anchor.get_child(0).get_child(0).monitoring = true
			melee_weapon_anchor.show()
		
		if sacrifice.weapon_type == Sacrifice.WeaponType.PROJECTILE:
			projectile_weapon_anchor.get_child(0).texture = sacrifice.projectile_weapon_sprite
			projectile_weapon_anchor.projectile_scene = sacrifice.projectile
			projectile_weapon_anchor.show()
		
		if index == 0:
			vignette_player.play("show")
	else:
		body_part.show()
		max_health += sacrifice.health_decrease
		health += sacrifice.health_decrease
		jump_speed -= sacrifice.jump_boost
		no_of_sacrifices -= 1
		
		if sacrifice.weapon_type == Sacrifice.WeaponType.MELEE:
			melee_weapon_anchor.hide()
			melee_weapon_anchor.get_child(0).get_child(0).monitoring = false
		
		if sacrifice.weapon_type == Sacrifice.WeaponType.PROJECTILE:
			projectile_weapon_anchor.hide()
			
		if index == 0:
			vignette_player.play("hide")

	var label: Label = health_meter.get_node("Label")
	label.text = "%s/%s" % [health, max_health]
	health_meter.max_value = max_health
	health_meter.value = health

func _on_hurtbox_hit(area: Area2D) -> void:
	if area is EnemyHitbox:
		receive_knockback(area.global_position, area.damage, Vector2(25, 25))
		HitStop.hit_stop(0, 0.25)
		CameraShake.shake(1, 0.1)
		health -= area.damage
		health_meter.value = health
		health_meter.get_node("Label").text = "%s/%s" % [health, max_health]
		
		for i in sacrificable_body_parts:
			i.material.set_shader_parameter("flashing", true)
		
		$HitTimer.start()

func _on_pause_button_pressed() -> void:
	pause_panel.show()
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(pause_panel.get_child(1), "position", Vector2(352, 98), 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_callback(pause_game)

func pause_game() -> void:
	get_tree().paused = true

func receive_knockback(damage_source_pos: Vector2, recieved_damage: int, knockback_strength: Vector2 = Vector2(0, 0), stop_time: float = 0.25) -> void:
	var knockback_direction: Vector2 = damage_source_pos.direction_to(global_position)
	
	knockback = knockback_strength * knockback_direction * recieved_damage
	
	if knockback_tween:
		knockback_tween.kill()
	
	knockback_tween = get_tree().create_tween()
	knockback_tween.parallel().tween_property(self, "knockback", Vector2(0, 0), stop_time)

func _on_hit_timer_timeout() -> void:
	for i in sacrificable_body_parts:
		i.material.set_shader_parameter("flashing", false)
