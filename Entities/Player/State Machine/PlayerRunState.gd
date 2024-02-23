class_name PlayerRunState
extends PlayerState

# Reference to the relevant nodes that need to work when the player is in this state
@export var actor: Player					# Pass the player's CharacterBody2D
@export var animator: AnimatedSprite2D		# Pass the player's AnimatedSprite2D

# Signals this state will emit to let the state machine know when to switch to another state
signal released_left_or_right
signal pressed_jump

# Add anything that needs to be done when loaded
func _ready():
	pass

# Add stuff to do when player enters this state
func _enter_state() -> void:
	set_physics_process(true)	# turn on physics when player enters this state
	print("Entered Run State")

# Add stuff to do when player leaves this state
func _exit_state() -> void:
	set_physics_process(false) # turn off physics when changing states to save memory
	print("Exited Run State")

# Place conditions on when to emit the signals as well as general stuff that needs to happen
func _process(delta):
	if Input.is_action_just_pressed("jump") and actor.is_on_floor():
		pressed_jump.emit()
	
	# Get the input direction and handle the movement.
	var direction = Input.get_axis("left", "right")
	if direction:
		actor.velocity.x += direction * actor.acceleration
	else:
		actor.velocity.x += 0
		released_left_or_right.emit()
	
	# Slow down horizontal movement (friction)
	if actor.velocity.x > 10:
		actor.velocity.x -= 20
	elif actor.velocity.x < -10:
		actor.velocity.x += 20
	else:
		actor.velocity.x = 0
	
	# Cap the max speed
	if actor.velocity.x > actor.max_speed:
		actor.velocity.x = actor.max_speed
	if actor.velocity.x < actor.max_speed * -1:
		actor.velocity.x = actor.max_speed * -1
	
	actor.move_and_slide()
