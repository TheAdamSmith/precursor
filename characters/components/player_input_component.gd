class_name PlayerInputComponent
extends Node

@export var character : CharacterBody2D
@export var upgrade_component : UpgradeComponent
@export var stat_component : StatComponent


func _ready():
	if not character:
		character = get_parent()
	assert(character is CharacterBody2D)


func _unhandled_input(event):
	if not is_multiplayer_authority():
		set_process(false)
		set_process_input(false)
		return
	var moveDirection = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down",
	)
	character.velocity = moveDirection * stat_component.get_current_speed()
	var upgrade_vec
	if event.is_action_pressed("up_upgrade"):
		upgrade_vec = Vector2i.UP
	elif event.is_action_pressed("down_upgrade"):
		upgrade_vec = Vector2i.DOWN
	elif event.is_action_pressed("right_upgrade"):
		upgrade_vec = Vector2i.RIGHT
	elif event.is_action_pressed("left_upgrade"):
		upgrade_vec = Vector2i.LEFT
	else:
		return
	upgrade_component.upgrade_input.emit(upgrade_vec)
