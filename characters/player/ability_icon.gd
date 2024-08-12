class_name AbilityIcon
extends Sprite2D

@onready var cooldown_progress = $TextureProgressBar

var _cooldown_timer : SceneTreeTimer
var _total_time_sec : float


func set_timer(cooldown_timer):
	_cooldown_timer = cooldown_timer
	_total_time_sec = cooldown_timer.time_left


func _process(delta):
	if _cooldown_timer:
		cooldown_progress.value = cooldown_progress.max_value * (1 - _cooldown_timer.time_left / _total_time_sec)
	else:
		cooldown_progress.value = cooldown_progress.max_value
