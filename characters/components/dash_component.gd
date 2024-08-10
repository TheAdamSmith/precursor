class_name DashComponent
extends Node2D

@onready var trail = $Trail

@export var dash_speed_multiplier : float
@export var dash_duration_sec : float
@export var cooldown_duration_sec : float
@export var dash_invulnerability = false
@export var invulnerability_duration_sec = 0.0
@export var dash_intangibility = false
@export var intangibility_duration_sec = 0.0
@export var stat_component : StatComponent
@export var health_component : HealthComponent

var cooldown_timer : SceneTreeTimer
var dash_timer : SceneTreeTimer
var trail_queue : Array


func _ready():
	trail.stop_adding_points()


func _unhandled_input(event):
	if cooldown_timer and cooldown_timer.time_left != 0.0:
		return
	if event.is_action_pressed("dash"):
		stat_component.register_temp_multiplier("speed", dash_speed_multiplier, dash_duration_sec)
		cooldown_timer = get_tree().create_timer(cooldown_duration_sec)
		dash_timer = get_tree().create_timer(dash_duration_sec) 
		trail.start_adding_points()
		if dash_invulnerability:
			health_component.set_invulnerable(invulnerability_duration_sec)


func _physics_process(delta):
	if dash_timer and dash_timer.time_left == 0.0:
		trail.stop_adding_points()
