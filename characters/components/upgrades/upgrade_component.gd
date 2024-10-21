class_name UpgradeComponent
extends Node2D
# NOTE: All functionality should be defined in child classes


func _upgrade_stats(stat_component, stat_scaler, upgrade_level):
	stat_component.register_all_adders(stat_scaler.per_level_stat_adders)
	stat_component.register_all_multipliers(stat_scaler.per_level_stat_multipliers)
	if upgrade_level in stat_scaler.level_specific_adders:
		stat_component.register_all_adders(stat_scaler.level_specific_adders[upgrade_level])
	if upgrade_level in stat_scaler.level_specific_multipliers:
		stat_component.register_all_multipliers(stat_scaler.level_specific_multipliers[upgrade_level])


func _apply_buff(stat_component, adders_dict, multipliers_dict, buff_duration):
	stat_component.register_all_temp_adders(adders_dict, buff_duration)
	stat_component.register_all_temp_multipliers(multipliers_dict, buff_duration)
