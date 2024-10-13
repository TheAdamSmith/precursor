class_name DashComponent
extends Node2D

@onready var ability_damage = $AbilityDamageComponent
@onready var trail = $Trail
@onready var stat_component = $DashStatComponent

@export var player : Player
@export var player_stat_component : StatComponent
@export var player_health_component : HealthComponent

var cooldown_timer : SceneTreeTimer
var dash_timer : SceneTreeTimer
var trail_queue : Array


func _ready():
	trail.stop_adding_points()


func _unhandled_input(event):
	if cooldown_timer and cooldown_timer.time_left != 0.0:
		return
	if event.is_action_pressed("dash"):
		dash()


func dash():
	player_stat_component.register_temp_multiplier(
		"speed",
		stat_component.get_current_speed_multiplier(),
		stat_component.get_current_duration_sec(),
	)
	cooldown_timer = get_tree().create_timer(stat_component.get_current_cooldown_duration_sec(), false, true)
	dash_timer = get_tree().create_timer(stat_component.get_current_duration_sec(), false, true)
	ability_damage.set_active()
	trail.start_adding_points()
	if player and stat_component.get_current_invulnerability_duration_sec() != 0.0:
		player_health_component.set_invulnerable(stat_component.get_current_invulnerability_duration_sec())
	if player and stat_component.get_current_intangibility_duration_sec() != 0.0:
		player.set_intangible(stat_component.get_current_intangibility_duration_sec())


func _physics_process(delta):
	if dash_timer and dash_timer.time_left == 0.0:
		ability_damage.set_inactive()
		trail.stop_adding_points()
