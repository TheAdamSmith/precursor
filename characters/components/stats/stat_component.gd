class_name StatComponent
extends Node

# Other components can connect to this signal
signal stat_updated(stat_name)


@export var _base_stats = {}

var _stat_adders = {}
var _stat_multipliers = {}
var _temp_adders = {}
var _temp_multipliers = {}
var _stat_cached = {} # Dictionary of 2 item lists containing [cached : bool, cache_val : float]


func _ready():
	if _base_stats:
		set_base_stats(_base_stats)


func set_base_stats(base_stats):
	_base_stats = base_stats
	for stat_name in _base_stats.keys():
		_stat_adders[stat_name] = []
		_stat_multipliers[stat_name]  = []
		_temp_adders[stat_name] = []
		_temp_multipliers[stat_name]  = []
		_stat_cached[stat_name] = [true, _base_stats[stat_name]]
		stat_updated.emit(stat_name)


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
	for temp_dict in _temp_multipliers[stat_name]:
		if temp_dict["timer"].time_left != 0.0:
			sum += temp_dict["multiplier"]
	if sum == 0.0:
		return 1.0
	return sum


func _register_stat_adder(stat_name, adder, emit=true):
	_stat_cached[stat_name][0] = false
	_stat_adders[stat_name].append(adder)
	if emit:
		stat_updated.emit(stat_name)


func _register_stat_multiplier(stat_name, multiplier, emit=true):
	_stat_cached[stat_name][0] = false
	_stat_multipliers[stat_name].append(multiplier)
	if emit:
		stat_updated.emit(stat_name)


func register_all_adders(stat_dict, num_times=1, emit=true):
	for stat_name in stat_dict.keys():
		_register_stat_adder(stat_name, stat_dict[stat_name] * num_times, emit)
	


func register_all_multipliers(stat_dict, num_times=1, emit=true):
	for stat_name in stat_dict.keys():
		_register_stat_multiplier(stat_name, stat_dict[stat_name] * num_times, emit)


func register_temp_adder(stat_name, adder, duration_sec, emit=true):
	_stat_cached[stat_name][0] = false
	var stat_timer = get_tree().create_timer(duration_sec, false, true)
	stat_timer.timeout.connect(_clear_timed_out_stats)
	_temp_adders[stat_name].append({
		"adder": adder,
		"timer": stat_timer,
	})
	if emit:
		stat_updated.emit(stat_name)


func register_temp_multiplier(stat_name, multiplier, duration_sec, emit=true):
	_stat_cached[stat_name][0] = false
	var stat_timer = get_tree().create_timer(duration_sec, false, true)
	stat_timer.timeout.connect(_clear_timed_out_stats)
	_temp_multipliers[stat_name].append({
		"multiplier": multiplier,
		"timer": stat_timer,
	})
	if emit:
		stat_updated.emit(stat_name)


func _clear_timed_out_stats():
	for stat_name in _temp_multipliers.keys():
		var remove_indexs = []
		for i in _temp_multipliers[stat_name].size():
			var temp_stat_dict = _temp_multipliers[stat_name][i]
			if temp_stat_dict["timer"].time_left == 0:
				remove_indexs.append(i)
		for remove_idx in remove_indexs:
			_temp_multipliers[stat_name].remove_at(remove_idx)
			_stat_cached[stat_name][0] = false
			stat_updated.emit(stat_name)
	for stat_name in _temp_adders.keys():
		var remove_indexs = []
		for i in _temp_adders[stat_name].size():
			var temp_stat_dict = _temp_adders[stat_name][i]
			if temp_stat_dict["timer"].time_left == 0:
				remove_indexs.append(i)
		for remove_idx in remove_indexs:
			_temp_adders[stat_name].remove_at(remove_idx)
			_stat_cached[stat_name][0] = false
			stat_updated.emit(stat_name)


func _print_all_stats():
	for stat_name in _base_stats.keys():
		print("%s: %1.2f" % [stat_name, _get_modified_stat(stat_name)])
