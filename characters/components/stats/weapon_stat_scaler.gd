class_name WeaponStatScaler
extends Resource

# NOTE: These values are not meant to be changed
# If you want to change values for a specific character/weapon, 
# update or create a new .tres file

@export var base_stats = {
	"fire_rate": 0.0,
	"bullet_speed": 0.0,
	"bullet_damage": 0.0,
	"piercing_num": 0,
	"aoe_damage": 0.0,
	"aoe_scale": 0.0,
	"num_bullets_per_shot": 0,
	"bullet_spread_deg": 0.0,
}

@export var per_level_stat_adders = {
	"fire_rate": 0.0,
	"bullet_speed": 0.0,
	"bullet_damage": 0.0,
	"piercing_num": 0,
	"aoe_damage": 0.0,
	"aoe_scale": 0.0,
	"num_bullets_per_shot": 0,
	"bullet_spread_deg": 0.0,
}

@export var per_level_stat_multipliers = {
	"fire_rate": 0.0,
	"bullet_speed": 0.0,
	"bullet_damage": 0.0,
	"piercing_num": 0,
	"aoe_damage": 0.0,
	"aoe_scale": 0.0,
	"num_bullets_per_shot": 0,
	"bullet_spread_deg": 0.0,
}

@export var level_specific_adders = {
	1: {
		"fire_rate": 0.0,
		"bullet_speed": 0.0,
		"bullet_damage": 0.0,
		"piercing_num": 0,
		"aoe_damage": 0.0,
		"aoe_scale": 0.0,
		"num_bullets_per_shot": 0,
		"bullet_spread_deg": 0.0,
	}
}

@export var level_specific_multipliers = {
	1: {
		"fire_rate": 0.0,
		"bullet_speed": 0.0,
		"bullet_damage": 0.0,
		"piercing_num": 0,
		"aoe_damage": 0.0,
		"aoe_scale": 0.0,
		"num_bullets_per_shot": 0,
		"bullet_spread_deg": 0.0,
	}
}
