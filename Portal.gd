extends Area2D

@export var target_scene_path: String = "res://Level1.tscn"
@export var transport_delay: float = 1.0  

@onready var prompt_label = $Label
@onready var portal_anim = $AnimatedSprite2D

var player_in_range = false
var has_teleported = false

func _ready():
	portal_anim.play("portal")  
	prompt_label.visible = false

func _on_body_entered(body):
	if body.name == "Player" and not has_teleported:
		player_in_range = true
		prompt_label.visible = true
		has_teleported = true  
		await get_tree().create_timer(transport_delay).timeout
		get_tree().change_scene_to_file(target_scene_path)

func _on_body_exited(body):
	if body.name == "Player":
		player_in_range = false
		prompt_label.visible = false
