class_name StateMachine
extends Node

signal transition(curr : State, next : State)

@export var initial_state : State

var current_state : State
var _initial_entered = false

func _ready():
	current_state = initial_state
	transition.connect(_on_state_transition)


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


func _on_state_transition(curr : State, next : State):
	if curr != current_state:
		print("Warning: state %s is not the current state" % curr)
		return
	current_state.exit()
	current_state = next
	current_state.enter()
