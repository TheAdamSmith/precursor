class_name ChargeAttackPlayerState
extends EnemyState

@export var next_state : EnemyState
@export var dash_component : DashComponent

var dashed = false


func _ready():
	super._ready()
	dash_component.set_process_unhandled_input(false)


func enter():
	super.enter()
	dashed = false
	enemy.animation_change.emit("charging")


func physics_process(delta):
	if not player:
		_find_player()
	if not is_instance_valid(player):
		return
	if not dashed:
		var direction = player.global_position - global_position
		enemy.move_direction = direction
		dash_component.dash()
		dashed = true
	if dash_component.dash_timer and dash_component.dash_timer.time_left == 0.0:
		if next_state is CooldownState:
			next_state.set_cooldown_time_sec(dash_component.stat_component.get_current_cooldown_duration_sec())
		_transition(next_state)


func exit():
	enemy.move_direction = Vector2.ZERO
