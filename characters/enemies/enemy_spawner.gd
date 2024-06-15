extends Node2D
class_name EnemySpawner

@export var min_x : int
@export var max_x : int
@export var min_y : int
@export var max_y : int
@export var spawn_time = 1.0
@export var enemy_spawn_scaler : EnemySpawnScaler
var spawn_timer : SceneTreeTimer
var disabled = false
var arena_group

var num_enemies_spawned = 0
var spawner_level = 1

var _enemy_base_stats
var _enemy_exp
var _enemy_models

func spawn_enemy():
	if num_enemies_spawned / spawner_level >= enemy_spawn_scaler.enemy_spawns_per_level:
		print("SPAWNER LEVELED")
		spawner_level += 1
	if spawner_level in enemy_spawn_scaler.spawner_stats_by_level.keys():
		_enemy_base_stats = enemy_spawn_scaler.spawner_stats_by_level[spawner_level]["base_stats"]
		_enemy_exp = enemy_spawn_scaler.spawner_stats_by_level[spawner_level]["exp_given"]
		_enemy_models = enemy_spawn_scaler.spawner_stats_by_level[spawner_level]["enemy_models"]
	var position = Vector2(randi_range(min_x,max_x),randi_range(min_y,max_y))
	var enemy_model = _enemy_models.pick_random()
	var enemy_sprite = load("res://characters/enemies/enemy_models/" + enemy_model + ".tscn").instantiate()
	
	#set a generic name for the sprite frame object so that it can be referenced generically
	enemy_sprite.set_name("enemySprite")
	
	var enemy = load("res://characters/enemies/enemy.tscn").instantiate()
	enemy.add_child(enemy_sprite)
	enemy.global_position = position
	enemy.add_to_group("enemy")
	if not arena_group:
		arena_group = ArenaUtilities.get_arena_name_by_position(enemy.global_position)
	enemy.add_to_group(arena_group)
	enemy.experience_given = _enemy_exp
	enemy.get_node("StatComponent")._base_stats = _enemy_base_stats
	add_child(enemy)
	num_enemies_spawned += 1


func _physics_process(delta):
	if not disabled and (not spawn_timer or spawn_timer.time_left == 0.0):
		if arena_group and ArenaUtilities.get_count_in_arena_by_group(get_tree(), "player", arena_group) == 0:
			disabled = true
			return
		spawn_enemy()
		spawn_timer = get_tree().create_timer(spawn_time)
