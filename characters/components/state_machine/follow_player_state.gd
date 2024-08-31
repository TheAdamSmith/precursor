class_name FollowPlayerState
extends EnemyState


func physics_process(delta):
	if not player:
		_find_player()
	if not is_instance_valid(player):
		return
	var direction = enemy.global_position.direction_to(player.global_position)
	enemy.move_direction = direction
