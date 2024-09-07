class_name EnemyUpgradeComponent
extends UpgradeComponent

@export var stat_component : StatComponent
@export var stat_scaler : StatScaler
@export var enemy_tier_modifier : EnemyTierModifier


func level_up(num_levels):
	for level in num_levels:
		_upgrade_stats(stat_component, stat_scaler, level)


func set_tier(tier : EnemyTierModifier.EnemyTier):
	stat_component.register_all_multipliers(enemy_tier_modifier.stat_multipliers_by_tier[tier])
