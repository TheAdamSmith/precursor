class_name ComputerPlayerInputComponent
extends Node2D

@export var character : CharacterBody2D
@export var speed : float
var timer : SceneTreeTimer


func _ready():
	if not character:
		character = get_parent()
	assert(character is CharacterBody2D)


func _physics_process(delta):
	if timer and timer.time_left != 0:
		return
	timer = get_tree().create_timer(randf_range(1,5))
	var moveDirection = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
	character.velocity = moveDirection * speed
