class_name EnemySpawnScaler
extends Resource

@export var enemy_spawns_per_level = 50
@export var spawner_stats_by_level = {
	1: {
		"enemy_models": ["alien_v1", "alien_v2"],
		"exp_given": .22,
		"base_stats": {
			"speed": 100,
			"health": 30,
			"attacks_per_sec": 1.0,
			"damage": 5.0,
		}
	},
	5: {
		"enemy_models": ["alien_v1", "alien_v2"],
		"exp_given": 12.14,
		"base_stats": {
			"speed": 150,
			"health": 120,
			"attacks_per_sec": 1.0,
			"damage": 15.0,
		}
	}
}
