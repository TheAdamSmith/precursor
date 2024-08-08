class_name DashComponent
extends Node

@export var dash_speed_multiplier : float
@export var dash_duration_sec : float
@export var cooldown_duration_sec : float
@export var dash_invulnerability = false
@export var stat_component : StatComponent

var cooldown_timer : SceneTreeTimer


func _unhandled_input(event):
	if cooldown_timer and cooldown_timer.time_left != 0.0:
		return
	if event.is_action_pressed("dash"):
		stat_component.register_temp_multiplier("speed", dash_speed_multiplier, dash_duration_sec)
		cooldown_timer = get_tree().create_timer(cooldown_duration_sec)
