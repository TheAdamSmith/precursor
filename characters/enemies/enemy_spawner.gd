extends Node2D
class_name EnemySpawner

@export var min_x : int
@export var max_x : int
@export var min_y : int
@export var max_y : int
@export var spawn_time = 1.0
@export var enemy_spawn_scaler : EnemySpawnScaler

var spawn_timer : SceneTreeTimer
var level_up_timer : SceneTreeTimer
var disabled = false
var arena_group
var _enemy_model_scenes = {}

var num_enemies_spawned = 0
var spawner_level = 1

var _enemy_models
var _enemy_spawn_chance


func spawn_enemy():
	if disabled:
		return
	if spawner_level in enemy_spawn_scaler.enemy_models_by_level.keys():
		_enemy_models = enemy_spawn_scaler.enemy_models_by_level[spawner_level]
	if spawner_level in enemy_spawn_scaler.enemy_tier_spawn_chance_by_level.keys():
		_enemy_spawn_chance = enemy_spawn_scaler.enemy_tier_spawn_chance_by_level[spawner_level]
	var enemy_tier = _get_random_enemy_tier()
	var position = Vector2(randi_range(min_x,max_x),randi_range(min_y,max_y))
	var enemy_model = _enemy_models.pick_random()
	# cache loaded scenes of enemies so they don't have to be reloaded every time
	if enemy_model not in _enemy_model_scenes.keys():
		_enemy_model_scenes[enemy_model] = load("res://characters/enemies/enemy_types/" + enemy_model + ".tscn")
	var enemy = _enemy_model_scenes[enemy_model].instantiate()

	enemy.global_position = position
	enemy.add_to_group("enemy")
	enemy.upgrade_component.tier = enemy_tier
	add_child(enemy)
	if not arena_group:
		arena_group = ArenaUtilities.get_arena_name_by_position(enemy.global_position)
	enemy.add_to_group(arena_group)
	_set_enemy_stats(enemy)
	num_enemies_spawned += 1


func _get_random_enemy_tier():
	var rand_spawn = randf_range(0.0, 1.0)
	var chance_sum = 0.0
	var ret_type
	var ret_type_set = false
	for enemy_tier in EnemySpawnScaler.EnemyTier.values():
		chance_sum += _enemy_spawn_chance[enemy_tier]
		if ret_type == null and rand_spawn <= chance_sum:
			ret_type = enemy_tier
	assert(is_equal_approx(chance_sum, 1.0), "ERROR: Sum of spawn chances must equal 1.0 but was %f" % chance_sum)
	return ret_type


func _set_enemy_stats(enemy : Enemy):
	enemy.upgrade_component.initialize_stats()
	enemy.upgrade_component.level_up(spawner_level)
	enemy.upgrade_component.set_tier_modifiers()                    


func _physics_process(delta):
	if disabled:
		return
	if not spawn_timer or spawn_timer.time_left == 0.0:
		if arena_group and ArenaUtilities.get_count_in_arena_by_group(get_tree(), "player", arena_group) == 0:
			disabled = true
			return
		spawn_enemy()
		spawn_timer = get_tree().create_timer(spawn_time)
	if not level_up_timer:
		level_up_timer = get_tree().create_timer(enemy_spawn_scaler.sec_per_spawner_level_up)
		return
	if level_up_timer.time_left == 0.0:
		spawner_level += 1
		level_up_timer = get_tree().create_timer(enemy_spawn_scaler.sec_per_spawner_level_up)
