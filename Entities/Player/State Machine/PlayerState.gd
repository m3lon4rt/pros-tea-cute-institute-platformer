# State superclass that all player states inherit from
class_name PlayerState
extends Node

signal state_finished

func _enter_state() -> void:
	pass
	
func _exit_state() -> void:
	pass
