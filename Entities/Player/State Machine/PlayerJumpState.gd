class_name PlayerJumpState
extends PlayerState

# Reference to the relevant nodes that need to work when the player is in this state
@export var actor: Player					# Pass the player's CharacterBody2D
@export var animator: AnimatedSprite2D		# Pass the player's AnimatedSprite2D

# Signals this state will emit to let the state machine know when to switch to another state
signal pressed_left_or_right
signal falling

# Add anything that needs to be done when loaded
func _ready():
	pass

# Add stuff to do when player enters this state
func _enter_state() -> void:
	set_physics_process(true)	# turn on physics when player enters this state
	actor.velocity.y -= actor.jump_velocity
	
	print("Entered Jump State")

# Add stuff to do when player leaves this state
func _exit_state() -> void:
	set_physics_process(false) # turn off physics when changing states to save memory
	print("Exited Jump State")

# Place conditions on when to emit the signals as well as general stuff that needs to happen
func _process(delta):
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		pressed_left_or_right.emit()
	
	if actor.velocity.y > 0:
		falling.emit()
	
	if not actor.is_on_floor():
		actor.velocity.y += actor.gravity * delta
	actor.move_and_slide()
