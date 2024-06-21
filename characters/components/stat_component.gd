class_name StatComponent
extends Node

# Other components can connect to this signal
signal stat_updated(stat_name)


@export var _base_stats = {
	"speed": 200,
	"health": 100,
	"attacks_per_sec": 1.0,
	"damage": 10.0,
}

var _stat_adders = {}
var _stat_multipliers = {}
var _stat_cached = {} # Dictionary of 2 item lists containing [cached : bool, cache_val : float]


func _ready():
	if _base_stats:
		set_base_stats(_base_stats)


func set_base_stats(base_stats):
	_base_stats = base_stats
	for stat_name in _base_stats.keys():
		_stat_adders[stat_name] = []
		_stat_multipliers[stat_name]  = []
		_stat_cached[stat_name] = [true, _base_stats[stat_name]]


func invalidate_cache():
	for stat_name in _base_stats.keys():
		_stat_cached[stat_name] = [false, null]


func _get_modified_stat(stat_name):
	var cache = _stat_cached[stat_name]
	if cache[0]:
		return cache[1]
	# Add first then multiply
	var modified_stat = (_base_stats[stat_name] + _get_adder_sum(stat_name)) * _get_multiplier_sum(stat_name)
	cache[0] = true
	cache[1] = modified_stat
	return modified_stat


func _get_adder_sum(stat_name):
	var sum = 0.0
	for adder in _stat_adders[stat_name]:
		sum += adder
	return sum
 

func _get_multiplier_sum(stat_name):
	var sum = 0.0
	for multiplier in _stat_multipliers[stat_name]:
		sum += multiplier
	if sum == 0.0:
		return 1.0
	return sum


func _register_stat_adder(stat_name, adder):
	_stat_cached[stat_name][0] = false
	_stat_adders[stat_name].append(adder)
	stat_updated.emit(stat_name)


func _register_stat_multiplier(stat_name, multiplier):
	_stat_cached[stat_name][0] = false
	_stat_multipliers[stat_name].append(multiplier)
	stat_updated.emit(stat_name)


func register_all_adders(stat_dict, num_times=1):
	for stat_name in stat_dict.keys():
		_register_stat_adder(stat_name, stat_dict[stat_name] * num_times)


func register_all_multipliers(stat_dict, num_times=1):
	for stat_name in stat_dict.keys():
		_register_stat_multiplier(stat_name, stat_dict[stat_name] * num_times)


func _print_all_stats():
	for stat_name in _base_stats.keys():
		print("%s: %1.2f" % [stat_name, _get_modified_stat(stat_name)])


func get_current_speed():
	return _get_modified_stat("speed")


func get_current_health():
	return _get_modified_stat("health")


func get_current_attacks_per_sec():
	return _get_modified_stat("attacks_per_sec")


func get_current_damage():
	return _get_modified_stat("damage")
