extends Node2D
class_name Projectile

@export var speed: float
@export var damage: int
@export var hitbox: Hitbox
@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var destroy_timer: Timer = $DestroyTimer

func _ready() -> void:
	destroy_timer.timeout.connect(queue_free)
	hitbox.damage = damage

func _process(delta: float) -> void:
	translate(transform.x * speed * delta)
