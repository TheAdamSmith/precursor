class_name AbilityIcon
extends Control

@onready var cooldown_progress = $TextureProgressBar

@export var ability_component : DashComponent

var _prev_timer : SceneTreeTimer
var _total_time_sec : float


func _process(delta):
	if ability_component.cooldown_timer and ability_component.cooldown_timer != _prev_timer:
		_prev_timer = ability_component.cooldown_timer
		_total_time_sec = ability_component.cooldown_timer.time_left
	if _prev_timer:
		cooldown_progress.value = cooldown_progress.max_value * (1 - _prev_timer.time_left / _total_time_sec)
	else:
		cooldown_progress.value = cooldown_progress.max_value
