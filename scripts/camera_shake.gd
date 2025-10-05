extends Node

var camera: Camera2D

var camera_shake_intensity: float
var camera_shake_duration: float

func _ready() -> void:
	if not camera:
		push_warning("No camera specified")

func shake(intensity: float, duration: float) -> void:
	if not camera: 
		return
	
	camera_shake_intensity = intensity
	camera_shake_duration = duration

func _process(delta: float) -> void:
	if not camera:
		return
	
	if camera_shake_duration <= 0:
		camera.offset = Vector2.ZERO
		camera_shake_intensity = 0.0
		camera_shake_duration = 0.0
		return
	
	camera_shake_duration = camera_shake_duration - delta
	
	var offset: Vector2 = Vector2.ZERO
	offset = Vector2(randf(), randf()) * camera_shake_intensity
	
	camera.offset = offset
