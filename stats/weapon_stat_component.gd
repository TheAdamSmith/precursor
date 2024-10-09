class_name WeaponStatComponent
extends StatComponent

## Dict of stat_name -> base val.
## NOTE: Can be updated for one-off test scenes, but should be set 
##  by an upgrade component using its stat_scaler.base_stats
@export var base_stats = { # Do NOT update values in this script and expect stats to change in game
	"fire_rate": 0.0,
	"bullet_speed": 0.0,
	"bullet_damage": 0.0,
	"aoe_damage": 0.0,
	"aoe_scale": 0.0,
	"piercing_num": 0,
	"num_bullets_per_shot": 0,
	"bullet_spread_deg": 0.0,
}


func _ready():
	_base_stats = base_stats
	super._ready()


func get_current_fire_rate():
	return _get_modified_stat("fire_rate")


func get_current_bullet_speed():
	return _get_modified_stat("bullet_speed")


func get_current_bullet_damage():
	return _get_modified_stat("bullet_damage")


func get_current_aoe_damage():
	return _get_modified_stat("aoe_damage")


func get_current_aoe_scale():
	return _get_modified_stat("aoe_scale")


func get_current_piercing_num():
	return _get_modified_stat("piercing_num")


func get_current_num_bullets_per_shot():
	return _get_modified_stat("num_bullets_per_shot")


func get_current_bullet_spread_deg():
	return _get_modified_stat("bullet_spread_deg")
