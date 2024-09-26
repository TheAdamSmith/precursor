class_name ChargingEnemyUpgradeComponent
extends EnemyUpgradeComponent

@export var dash_stat_component : DashStatComponent
@export var dash_stat_scaler : DashStatScaler
@export var dash_tier_modifier : EnemyTierModifier


func initialize_stats():
	super.initialize_stats()
	dash_stat_component.set_base_stats(dash_stat_scaler.base_stats)


func level_up(num_levels):
	super.level_up(num_levels)
	for level in num_levels:
		_upgrade_stats(dash_stat_component, dash_stat_scaler, level)


func set_tier_modifiers():
	super.set_tier_modifiers()
	if tier in dash_tier_modifier.stat_adders_by_tier:
		dash_stat_component.register_all_adders(dash_tier_modifier.stat_adders_by_tier[tier])
	if tier in dash_tier_modifier.stat_multipliers_by_tier:
		dash_stat_component.register_all_multipliers(dash_tier_modifier.stat_multipliers_by_tier[tier])
