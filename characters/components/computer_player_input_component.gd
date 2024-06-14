class_name ComputerPlayerInputComponent
extends Node2D

@export var player : Player
@export var upgrade_component : UpgradeComponent
@export var stat_component : StatComponent
var timer : SceneTreeTimer
var arena_center : Vector2
var max_dist_to_center : float

var _prev_move_direction = Vector2.ZERO


func _ready():
	if not player:
		player = get_parent()
	assert(player is Player)


func _determine_weighted_movement_direction():
	var closest_enemy = ArenaUtilities.find_closest_in_arena_by_group(player, "enemy", player.arena_group)
	if not arena_center:
		arena_center = ArenaUtilities.get_arena_center(player.arena_group)
		max_dist_to_center = pow(pow(ArenaUtilities.ARENA_WIDTH, 2) + pow(ArenaUtilities.ARENA_HEIGHT, 2), .5) / 2
	if not closest_enemy:
		return
	var enemy_dist = closest_enemy.global_position.distance_to(global_position)
	var center_dist = global_position.distance_to(arena_center)
	var center_weight = (center_dist / max_dist_to_center)
	if center_dist < 1.0 or enemy_dist < ArenaUtilities.TILE_SIZE * 2:
		center_weight = 0
	var enemy_weight = 1.0 - center_weight
	var move_direction = (
		enemy_weight * closest_enemy.global_position.direction_to(global_position) + 
		center_weight * global_position.direction_to(arena_center) +
		_prev_move_direction
	).normalized()
	return move_direction


func _physics_process(delta):
	if not player or not is_instance_valid(player):
		return
	if upgrade_component and upgrade_component.upgrade_count > 0:
		var rand_x_upgrade = randi_range(-1, 1)
		var rand_y_upgrade = 0
		if rand_x_upgrade == 0:
			while rand_y_upgrade == 0:
				rand_y_upgrade = randi_range(-1, 1)
		upgrade_component.upgrade_input.emit(Vector2i(rand_x_upgrade, rand_y_upgrade))
	if timer and timer.time_left != 0:
		return
	timer = get_tree().create_timer(randf_range(.1,.5))
	var move_direction = _determine_weighted_movement_direction()
	if not move_direction:
		return
	_prev_move_direction = move_direction
	player.velocity = move_direction * stat_component.get_current_speed()
