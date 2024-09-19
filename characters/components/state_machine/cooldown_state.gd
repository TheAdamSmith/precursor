class_name CooldownState
extends EnemyState

@export var next_state : EnemyState
@export var cooldown_time_sec : float

var cooldown_timer : SceneTreeTimer


func enter():
	super.enter()
	cooldown_timer = get_tree().create_timer(cooldown_time_sec)


func physics_process(delta):
	if cooldown_timer and cooldown_timer.time_left == 0.0:
		_transition(next_state)
