class_name EnemySpawnScaler
extends Resource

enum EnemyType {
	TRASH,
	NORMAL,
	ELITE,
}

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
	5: ["alien_v1", "alien_v2"],
}
@export var enemy_type_spawn_chance_by_level = {
	1: {
		EnemyType.TRASH: 0.9,
		EnemyType.NORMAL: 0.1,
		EnemyType.ELITE: 0.0,
	}
}
@export var stat_multipliers_by_type = {
	EnemyType.TRASH: {
		"speed": 1.0,
		"health": 1.0,
		"attacks_per_sec": 1.0,
		"damage": 1.0,
		"exp": 1.0,
		"size": 1.0,
	},
	EnemyType.NORMAL: {
		"speed": 1.25,
		"health": 5.0,
		"attacks_per_sec": 1.5,
		"damage": 2.5,
		"exp": 5.0,
		"size": 1.5,
	},
	EnemyType.ELITE: {
		"speed": 1.5,
		"health": 10.0,
		"attacks_per_sec": 2,
		"damage": 5.0,
		"exp": 10.0,
		"size": 2.0,
	},
}
@export var shader_vals_by_type = {
	EnemyType.TRASH: {
		"red_adder": 0.0,
		"green_adder": 0.0,
		"blue_adder": 0.0,
	},
	EnemyType.NORMAL: {
		"red_adder": 0.5,
		"green_adder": -0.5,
		"blue_adder": -0.5,
	},
	EnemyType.ELITE: {
		"red_adder": 0.25,
		"green_adder": -0.5,
		"blue_adder": 0.25,
	},
}
