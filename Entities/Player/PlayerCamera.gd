class_name PlayerCamera
extends Camera2D

@export var actor: Player
@export var follow_speed = 0.25
@export var decay = 0.8  # How quickly the shaking stops [0, 1].
@export var max_offset = Vector2(100, 75)  # Maximum hor/ver shake in pixels.
@export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).

var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()
	
	if global_position.x > actor.global_position.x:
		global_position.x -= follow_speed
	if global_position.x < actor.global_position.x:
		global_position.x += follow_speed
	if global_position.y > actor.global_position.y:
		global_position.y -= follow_speed
	if global_position.y < actor.global_position.y:
		global_position.y += follow_speed

func shake():
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * randf_range(-1, 1)
	offset.x = max_offset.x * amount * randf_range(-1, 1)
	offset.y = max_offset.y * amount * randf_range(-1, 1)
