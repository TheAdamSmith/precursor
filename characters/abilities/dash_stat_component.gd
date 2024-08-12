class_name DashStatComponent
extends StatComponent


@export var base_stats = {
	"speed_multiplier": 0.0,
	"duration_sec": 0.0,
	"cooldown_duration_sec": 0.0,
	"damage": 0.0,
	"aoe_scale": 1.0,
	"invulnerability_duration_sec": 0.0,
	"intangibility_duration_sec":0.0,
	"knockback_power": 0.0,
	"stun_duration_sec": 0.0,
}


func _ready():
	_base_stats = base_stats
	super._ready()


func get_current_speed_multiplier():
	return _get_modified_stat("speed_multiplier")


func get_current_duration_sec():
	return _get_modified_stat("duration_sec")


func get_current_cooldown_duration_sec():
	return _get_modified_stat("cooldown_duration_sec")


func get_current_damage():
	return _get_modified_stat("damage")


func get_current_aoe_scale():
	return _get_modified_stat("aoe_scale")


func get_current_invulnerability_duration_sec():
	return _get_modified_stat("invulnerability_duration_sec")


func get_current_intangibility_duration_sec():
	return _get_modified_stat("intangibility_duration_sec")


func get_current_knockback_power():
	return _get_modified_stat("knockback_power")


func get_current_stun_duration_sec():
	return _get_modified_stat("stun_duration_sec")
