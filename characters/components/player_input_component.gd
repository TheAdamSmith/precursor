class_name PlayerInputComponent
extends MultiplayerSynchronizer

@export var character : CharacterBody2D
@export var upgrade_component : UpgradeComponent
@export var speed : float


func _ready():
	if not character:
		character = get_parent()
	assert(character is CharacterBody2D)
	# Only process for the local player.
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())


func _unhandled_input(event):
	var moveDirection = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down",
	)
	character.velocity = moveDirection * speed
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
