class_name StateMachine
extends Node

signal transition(curr : State, next : State)

@export var initial_state : State

var current_state : State
