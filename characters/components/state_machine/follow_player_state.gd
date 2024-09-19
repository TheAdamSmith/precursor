class_name FollowPlayerState
extends EnemyState

## If 0.0, transition on contact, if negative, never transition to attack
@export var transition_to_next_state_distance : float
@export var next_state : EnemyState
@export var slide_on_transition = false


func physics_process(delta):
	if not player:
		_find_player()
	if not is_instance_valid(player):
		return
	var direction = enemy.global_position.direction_to(player.global_position)
	var distance = enemy.global_position.distance_to(player.global_position)
	enemy.move_direction = direction
	if transition_to_next_state_distance == 0.0:
		for collision_idx in enemy.get_slide_collision_count():
			var collision = enemy.get_slide_collision(collision_idx)
			if collision.get_collider() is Player and next_state:
				_transition(next_state)
	elif distance < transition_to_next_state_distance:
		_transition(next_state)


func exit():
	if not slide_on_transition:
		enemy.move_direction = Vector2.ZERO
