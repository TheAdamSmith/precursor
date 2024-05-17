class_name MovementInputComponent
extends Node2D

@export var character : CharacterBody2D
@export var speed : float


func _ready():
	if not character:
		character = get_parent()
	assert(character is CharacterBody2D)


func _unhandled_input(event):
	var moveDirection = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down",
	)
	character.velocity = moveDirection * speed
