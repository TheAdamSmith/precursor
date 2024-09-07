class_name EnemySpawnScaler
extends Resource

enum EnemyTier {
	TRASH,
	NORMAL,
	ELITE,
}

@export var sec_per_spawner_level_up = 60
@export var enemy_models_by_level = {
	1: ["alien_v1", "alien_v2"],
	5: ["alien_v1", "alien_v2"],
}
@export var enemy_tier_spawn_chance_by_level = {
	1: {
		EnemyTier.TRASH: 0.9,
		EnemyTier.NORMAL: 0.1,
		EnemyTier.ELITE: 0.0,
	}
}
