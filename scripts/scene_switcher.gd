extends CanvasLayer

@onready var animation_player: AnimationPlayer = $Control/AnimationPlayer

var current_scene: Node2D = null

func _ready() -> void:
	var root: Window = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func switch_scene(scene: PackedScene) -> void:
	call_deferred("_deferred_switch_scene", scene)

func _deferred_switch_scene(scene: PackedScene):
	animation_player.play("hide")
	await animation_player.animation_finished
	current_scene.call_deferred("queue_free")
	current_scene = scene.instantiate()
	get_tree().root.call_deferred("add_child", current_scene)
	get_tree().set_deferred("current_scene", current_scene)
	animation_player.play("show")
