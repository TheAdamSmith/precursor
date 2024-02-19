class_name ExperienceComponent
extends Node

signal experience_update(experience)
signal level_update(level)

@export var max_level : int
@export var initial_level_threshold : int
@export var threshold_multiplier : int

var experience
var level

func _ready():
	experience = 0
	level = 0


func _get_exp_threshold():
	return pow(threshold_multiplier, level) * initial_level_threshold


func add_exp(exp):
	experience += exp
	experience_update.emit(experience)
	while experience >= _get_exp_threshold() and level != max_level:
		level += 1
		level_update.emit(level)


func remove_exp(exp):
	# Don't let experience fall below current level threshold
	experience = max(experience - exp, _get_exp_threshold())
	experience_update.emit(experience)
