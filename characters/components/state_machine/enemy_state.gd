class_name EnemyState
extends State

var arena_group : String
var player : Node2D
var enemy : DisplaceableCharacterBody2D


func _find_player():
	player = ArenaUtilities.find_closest_in_arena_by_group(enemy, "player", arena_group)
	return player


func enter():
	var curr_node = self
	while curr_node:
		if curr_node is DisplaceableCharacterBody2D:
			enemy = curr_node
			break
		curr_node = curr_node.get_parent()
	arena_group = ArenaUtilities.get_arena_name_by_position(enemy.global_position)
	_find_player()
