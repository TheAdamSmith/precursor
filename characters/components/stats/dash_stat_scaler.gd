class_name DashStatScaler
extends Resource

# Stat name -> adder val
@export var per_level_stat_adders = {
	"speed_multiplier": 0.0,
	"duration_sec": 0.0,
	"cooldown_duration_sec": 0.0,
	"damage": 0.0,
	"aoe_scale": 0.0,
	"invulnerability_duration_sec": 0.0,
	"intangibility_duration_sec":0.0,
	"knockback_power": 0.0,
	"stun_duration_sec": 0.0,
}

# Stat name -> multiplier val
@export var per_level_stat_multipliers = {
	"speed_multiplier": 0.0,
	"duration_sec": 0.0,
	"cooldown_duration_sec": 0.0,
	"damage": 0.0,
	"aoe_scale": 0.0,
	"invulnerability_duration_sec": 0.0,
	"intangibility_duration_sec":0.0,
	"knockback_power": 0.0,
	"stun_duration_sec": 0.0,
}

# dict[level] = Dict of stat name -> adder
@export var level_specific_adders : Dictionary = {
	1: {
		"speed_multiplier": 0.0,
		"duration_sec": 0.0,
		"cooldown_duration_sec": 0.0,
		"damage": 0.0,
		"aoe_scale": 0.0,
		"invulnerability_duration_sec": 0.0,
		"intangibility_duration_sec":0.0,
		"knockback_power": 0.0,
		"stun_duration_sec": 0.0,
	}
}

# dict[level] = Dict of stat name -> mutliplier
@export var level_specific_multipliers : Dictionary = {
	1: {
		"speed_multiplier": 0.0,
		"duration_sec": 0.0,
		"cooldown_duration_sec": 0.0,
		"damage": 0.0,
		"aoe_scale": 0.0,
		"invulnerability_duration_sec": 0.0,
		"intangibility_duration_sec":0.0,
		"knockback_power": 0.0,
		"stun_duration_sec": 0.0,
	}
}

