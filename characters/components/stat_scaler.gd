class_name StatScaler
extends Resource

# Stat name -> adder val
@export var per_level_stat_adders = {
	"speed": 0.0,
	"health": 0.0,
	"damage": 0.0,
	"attacks_per_sec": 0.0,
}

# Stat name -> multiplier val
@export var per_level_stat_multipliers = {
	"speed": 0.0,
	"health": 0.0,
	"damage": 0.0,
	"attacks_per_sec": 0.0,
}

# dict[level] = Dict of stat name -> adder
@export var level_specific_adders : Dictionary = {
	1: {
		"speed": 0.0,
		"health": 0.0,
		"damage": 0.0,
		"attacks_per_sec": 0.0,
	}
}

# dict[level] = Dict of stat name -> mutliplier
@export var level_specific_multipliers : Dictionary = {
	1: {
		"speed": 0.0,
		"health": 0.0,
		"damage": 0.0,
		"attacks_per_sec": 0.0,
	}
}

