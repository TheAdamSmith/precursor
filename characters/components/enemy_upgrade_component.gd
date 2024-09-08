class_name EnemyUpgradeComponent
extends UpgradeComponent

@export var tier : EnemyTierModifier.EnemyTier
@export var stat_component : CharacterStatComponent
@export var stat_scaler : CharacterStatScaler
@export var enemy_tier_modifier : EnemyTierModifier

var _shader : ShaderMaterial


func initialize_stats():
	stat_component.set_base_stats(stat_scaler.base_stats)


func set_shader(shader):
	_shader = shader


func level_up(num_levels):
	for level in num_levels:
		_upgrade_stats(stat_component, stat_scaler, level)


func set_tier_modifiers():
	if tier in enemy_tier_modifier.stat_adders_by_tier:
		stat_component.register_all_adders(enemy_tier_modifier.stat_adders_by_tier[tier])
	if tier in enemy_tier_modifier.stat_multipliers_by_tier:
		stat_component.register_all_multipliers(enemy_tier_modifier.stat_multipliers_by_tier[tier])


func set_enemy_shader_params():
	var shader_vals = enemy_tier_modifier.shader_vals_by_tier[tier]
	for shader_key in shader_vals.keys():
		var shader_val = shader_vals[shader_key]
		_shader.set_shader_parameter(shader_key, shader_val)
