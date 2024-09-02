class_name State
extends Node2D

var state_machine : StateMachine


func _ready():
	state_machine = get_parent()


func enter():
	pass


func exit():
	pass


func process(delta):
	pass


func physics_process(delta):
	pass


func _transition(next_state : State):
	state_machine.transition.emit(self, next_state)
