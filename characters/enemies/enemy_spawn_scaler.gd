class_name EnemySpawnScaler
extends Resource

enum EnemyTier {
	TRASH,
	NORMAL,
	ELITE,
}

@export var sec_per_spawner_level_up : float
## spawner level -> dict of enemy type string -> spawn chance
@export var enemy_type_spawn_chance_by_level = {
	#1: {
		#"melee_enemy": 0.4,
		#"ranged_enemy": 0.5,
		#"charging_enemy": 0.1,
	#},
}
## spawner level -> dict of enemy tier -> spawn chance
@export var enemy_tier_spawn_chance_by_level = {
	#1: {
		#EnemyTier.TRASH: 0.9,
		#EnemyTier.NORMAL: 0.1,
		#EnemyTier.ELITE: 0.0,
	#}
}
