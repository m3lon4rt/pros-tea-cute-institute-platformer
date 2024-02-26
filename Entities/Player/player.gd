class_name Player
extends CharacterBody2D

@export var max_speed = 80.0
@export var acceleration = 50.0
@export var jump_velocity = 200.0
var last_button = ""

# declare state machine and every state this entity has
@onready var state_machine = $StateMachine as FiniteState
@onready var idle_state = $StateMachine/Idle as PlayerIdleState
@onready var run_state = $StateMachine/Run as PlayerRunState
@onready var jump_state = $StateMachine/Jump as PlayerJumpState

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	# Link all the states and their signals
	idle_state.pressed_left_or_right.connect(state_machine.change_state.bind(run_state))
	idle_state.pressed_jump.connect(state_machine.change_state.bind(jump_state))
	run_state.released_left_or_right.connect(state_machine.change_state.bind(idle_state))
	run_state.pressed_jump.connect(state_machine.change_state.bind(jump_state))
	jump_state.landed.connect(state_machine.change_state.bind(idle_state))

func _physics_process(delta):
	if Input.is_action_just_pressed("left") and !is_on_wall():
		last_button = "left"
	if Input.is_action_just_pressed("right") and !is_on_wall():
		last_button = "right"
	
	if is_on_wall() and velocity.y > 100 or Input.is_action_pressed("jump") and velocity.y > 0:
		gravity = ProjectSettings.get_setting("physics/2d/default_gravity")/4
	else:
		gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
