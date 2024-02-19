class_name StatResource
extends Resource

@export var _base_speed = 400
@export var _base_damage = 10
@export var _base_health = 100
@export var _base_attack_speed = 1
@export var _base_exp_multiplier = 1

const names = {
	SPEED = "speed",
	DAMAGE = "damage",
	MASS = "mass",
	HEALTH = "health",
	ATTACK_SPEED = "attack_speed",
	EXP_MULTIPLIER = "exp_multiplier",
}

var _stat_dict = {}


func init_stats():
	var properties = get_property_list()
	for name in names.values():
		for property in properties:
			if property["name"] == "_base_" + name:
				_stat_dict[name] = {
					"base": get("_base_" + name),
					"multipliers": [1],
					"adders": [0],
				}


func get_modified_stat(stat_name):
	var sum_adders = 0
	for adder in _get_stat_adders(stat_name):
		sum_adders += adder
	var sum_multiplier = 0
	for multiplier in _get_stat_multipler(stat_name):
		sum_multiplier += multiplier
	return (_get_base_stat(stat_name) + sum_adders) * sum_multiplier


func _get_base_stat(stat_name):
	return _stat_dict[stat_name]["base"]


func _get_stat_multipler(stat_name):
	return _stat_dict[stat_name]["multipliers"]


func _get_stat_adders(stat_name):
	return _stat_dict[stat_name]["adders"]


func register_multiplier(stat_name, multiplier):
	_stat_dict[stat_name]["multipliers"].append(multiplier)


func register_adder(stat_name, adder):
	_stat_dict[stat_name]["adders"].append(adder)
