class_name RangedEnemyUpgradeComponent
extends EnemyUpgradeComponent

@export var gun_stat_component : WeaponStatComponent
@export var gun_stat_scaler : WeaponStatScaler
@export var gun_tier_modifier : EnemyTierModifier
@export var gun : Gun


func initialize_stats():
	super.initialize_stats()
	gun_stat_component.set_base_stats(gun_stat_scaler.base_stats)


func level_up(num_levels):
	super.level_up(num_levels)
	for level in num_levels:
		_upgrade_stats(gun_stat_component, gun_stat_scaler, level)


func set_tier_modifiers():
	super.set_tier_modifiers()
	if tier in gun_tier_modifier.stat_adders_by_tier:
		gun_stat_component.register_all_adders(gun_tier_modifier.stat_adders_by_tier[tier])
	if tier in gun_tier_modifier.stat_multipliers_by_tier:
		gun_stat_component.register_all_multipliers(gun_tier_modifier.stat_multipliers_by_tier[tier])
	if tier in gun_tier_modifier.shader_vals_by_tier:
		gun.bullet_shader_params = gun_tier_modifier.shader_vals_by_tier[tier]
