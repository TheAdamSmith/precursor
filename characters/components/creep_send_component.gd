class_name CreepSendComponent
extends Node2D


signal creep_send_update(
	current_value: float, next_send_value: float, current_combo: int)


@export var combo_time: float = 2.0
@export var combo_mult: float = 5.0
@export var subsequent_send_value_increase: float = 10.0
@export var creep_xp_mult: float = 50.0

var current_value: float = 0.0
var starting_next_send_value: float = 100.0
var next_send_value: float = starting_next_send_value
var current_combo: int = 0

@onready var timer: Timer = $Timer


func _ready():
	creep_send_update.emit(current_value, next_send_value, 0.0)


func add_progress(value: float):
	current_value += value + (current_combo * combo_mult)
	if current_value >= next_send_value:
		# send creeps over here
		EventService.creep_send.emit(get_parent())
		current_value = current_value - next_send_value
		next_send_value = next_send_value + subsequent_send_value_increase
	timer.start(combo_time)
	if (timer.time_left > 0):
		current_combo += 1
	creep_send_update.emit(current_value, next_send_value, current_combo)


func _on_timer_timeout() -> void:
	current_combo = 0
	next_send_value = starting_next_send_value
	creep_send_update.emit(current_value, next_send_value, current_combo)
