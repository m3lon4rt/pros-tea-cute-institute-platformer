extends Camera2D

@export var actor: Player
@export var follow_speed = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if global_position.x > actor.global_position.x+10:
		global_position.x -= follow_speed
	if global_position.x < actor.global_position.x-10:
		global_position.x += follow_speed
	if global_position.y > actor.global_position.y+10:
		global_position.y -= follow_speed
	if global_position.y < actor.global_position.y-10:
		global_position.y += follow_speed
