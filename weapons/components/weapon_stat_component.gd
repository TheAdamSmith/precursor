class_name WeaponStatComponent
extends StatComponent


@export var base_stats = {
	"fire_rate": 1.0,
	"bullet_speed": 500.0,
	"bullet_damage": 10.0,
	"aoe_damage": 0.0,
	"aoe_scale": 0.0,
	"piercing_num": 0,
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
