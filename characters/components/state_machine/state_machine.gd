class_name StateMachine
extends Node2D

@export var initial_state : State

var current_state : State
var _initial_entered = false

func _ready():
	current_state = initial_state


func _process(delta):
	if not _initial_entered:
		_initial_entered = true
		current_state.enter()
	current_state.process(delta)


func _physics_process(delta):
	if not _initial_entered:
		_initial_entered = true
		current_state.enter()
	current_state.physics_process(delta)


func transition(curr : State, next : State):
	if curr != current_state:
		return
	current_state.exit()
	current_state = next
	current_state.enter()
