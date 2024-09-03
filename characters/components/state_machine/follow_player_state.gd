class_name FollowPlayerState
extends EnemyState

## If 0.0, transition on contact, if negative, never transition to attack
@export var transition_to_attack_distance : float
@export var attack_state : AttackPlayerState


func physics_process(delta):
	if not player:
		_find_player()
	if not is_instance_valid(player):
		return
	var direction = enemy.global_position.direction_to(player.global_position)
	var distance = enemy.global_position.distance_to(player.global_position)
	enemy.move_direction = direction
	if transition_to_attack_distance == 0.0:
		for collision_idx in enemy.get_slide_collision_count():
			var collision = enemy.get_slide_collision(collision_idx)
			if collision.get_collider() is Player:
				_transition(attack_state)
	elif distance < transition_to_attack_distance:
		_transition(attack_state)


func exit():
	enemy.move_direction = Vector2.ZERO
