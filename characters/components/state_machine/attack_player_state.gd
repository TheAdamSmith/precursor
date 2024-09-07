class_name AttackPlayerState
extends EnemyState

@export var transition_to_follow_distance : float
@export var follow_state : FollowPlayerState
@export var attack_component : AttackComponenent


func enter():
	super.enter()
	attack_component.enabled = true
	attack_component.enemy = self.enemy


func exit():
	attack_component.enabled = false


func physics_process(delta):
	if not player:
		_find_player()
	if not is_instance_valid(player):
		return
	var dist_to_player = enemy.global_position.distance_to(player.global_position)
	if dist_to_player >= transition_to_follow_distance:
		_transition(follow_state)
