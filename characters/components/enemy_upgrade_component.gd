class_name EnemyUpgradeComponent
extends UpgradeComponent

@export var stat_component : StatComponent
@export var stat_scaler : StatScaler


func level_up(num_levels):
	for level in num_levels:
		_upgrade_stats(stat_component, stat_scaler, level)
