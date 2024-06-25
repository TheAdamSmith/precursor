class_name EnemySpawnScaler
extends Resource

@export var sec_per_spawner_level_up = 60
@export var exp_per_level_exponent = 3.57
@export var enemy_base_stats = {
	"speed": 100,
	"health": 10,
	"attacks_per_sec": 1.0,
	"damage": 1.0,
}
@export var per_level_enemy_stat_addders = {
	"speed": 5,
	"health": 30,
	"attacks_per_sec": 0.1,
	"damage": 5.0,
}
@export var per_level_enemy_stat_multipliers = {
	"speed": 0,
	"health": 0,
	"attacks_per_sec": 0,
	"damage": 0,
}
@export var enemy_models_by_level = {
	1: ["alien_v1", "alien_v2"],
	5: ["alien_v1", "alien_v2"]
}
