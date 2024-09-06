class_name StatScaler
extends Resource

# Stat name -> base val
@export var base_stats : Dictionary

# Stat name -> adder val
@export var per_level_stat_adders : Dictionary

# Stat name -> multiplier val
@export var per_level_stat_multipliers : Dictionary

# dict[level] = Dict of stat name -> adder
@export var level_specific_adders : Dictionary

# dict[level] = Dict of stat name -> mutliplier
@export var level_specific_multipliers : Dictionary
