extends PointLight2D

# Adjustable parameters
@export var speed := 50.0              # Base movement speed
@export var direction_change_interval := 1.0  # Seconds between direction changes
@export var noise_strength := 100.0    # Strength of Perlin noise offset

var velocity := Vector2.ZERO
var time_passed := 0.0
var noise := FastNoiseLite.new()

func _ready():
	randomize()
	noise.seed = randi()
	noise.frequency = 0.5
	_change_direction()

func _process(delta):
	time_passed += delta

	# Update direction periodically
	if time_passed >= direction_change_interval:
		_change_direction()
		time_passed = 0.0

	# Add Perlin noise for smooth randomness
	var noise_offset = Vector2(
		noise.get_noise_2d(position.x, time_passed),
		noise.get_noise_2d(position.y, time_passed)
	) * noise_strength

	position += (velocity + noise_offset) * delta

func _change_direction():
	# Pick a random direction
	var angle = randf_range(0, TAU)
	velocity = Vector2(cos(angle), sin(angle)) * speed
