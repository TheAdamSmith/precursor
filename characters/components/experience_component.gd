class_name ExperienceComponent
extends Node2D

signal experience_update(experience)
signal level_update(level)

@export var max_level : int
@export var initial_level_threshold : int
@export var threshold_multiplier : int
@export var exponent : float

var experience
var level


func _ready():
	experience = 0.0
	level = 1


func _get_exp_threshold(_level):
	if _level <= 0:
		return 0
	#return pow(threshold_multiplier, _level) * initial_level_threshold
	return pow(_level, exponent)


func add_exp(exp):
	experience += exp
	experience_update.emit(experience)
	while experience >= _get_exp_threshold(level) and level != max_level:
		level += 1
		level_update.emit(level)


func remove_exp(exp):
	# Don't let experience fall below current level threshold
	experience = max(experience - exp, _get_exp_threshold(level))
	experience_update.emit(experience)
