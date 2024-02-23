# Finite State Machine Class that handles state changing
class_name FiniteState
extends Node

# Make sure to pass a default state in the inspector
@export var state: PlayerState

# When ready, enter default state
func _ready():
	change_state(state)

# Function that handles state switching
func change_state(new_state: PlayerState):
	if state is PlayerState:
		state._exit_state()
	new_state._enter_state()
	state = new_state
