class_name CooldownState
extends EnemyState

@export var next_state : EnemyState
## Can be set by other states that transition to this one
@export var cooldown_time_sec : float

var cooldown_timer : SceneTreeTimer


func set_cooldown_time_sec(val_sec):
	cooldown_time_sec = val_sec


func enter():
	super.enter()
	cooldown_timer = get_tree().create_timer(cooldown_time_sec, false, true)
	enemy.animation_change.emit("idle")


func physics_process(delta):
	if cooldown_timer and cooldown_timer.time_left == 0.0:
		_transition(next_state)
