class_name DisplaceableCharacterBody2D
extends CharacterBody2D

@export var stat_component : CharacterStatComponent
@export var max_speed : float

var displaced = false
var displaced_timer : SceneTreeTimer
var base_displaced_max_speed_mult = 2.0
var tmp_max_speed_mult : float = base_displaced_max_speed_mult
var current_max_speed_mult : float:
	set(val):
		print("Cannot set current_max_speed_mult manually")
	get:
		if displaced_timer and displaced_timer.time_left != 0.0:
			return tmp_max_speed_mult
		else:
			return base_displaced_max_speed_mult

var move_direction : Vector2 = Vector2.ZERO :
	set(dir):
		move_direction = dir.normalized()
	get:
		return move_direction

var max_displaced_speed : float:
	set(val):
		print("Cannot set max_displaced_speed manually")
	get:
		return current_max_speed_mult * max_speed


func apply_impulse(impulse_vec : Vector2, max_speed_multiplier=base_displaced_max_speed_mult):
	if max_speed_multiplier > tmp_max_speed_mult:
		tmp_max_speed_mult = max_speed_multiplier
	velocity += impulse_vec / stat_component.get_current_mass()
	if not displaced_timer or displaced_timer.time_left == 0.0:
		displaced_timer = get_tree().create_timer(stat_component.get_current_displaced_duration_sec())
	displaced = true


func accelerate_and_collide(delta):
	if displaced_timer and displaced_timer.time_left == 0.0:
		tmp_max_speed_mult = base_displaced_max_speed_mult
		displaced = false
	if displaced:
		velocity += move_direction * stat_component.get_current_acceleration_after_displacement() * delta
	if displaced and velocity.length() >= max_displaced_speed:
		velocity = velocity.normalized() * max_displaced_speed
	if not displaced:
		velocity = move_direction * max_speed
		move_and_slide()
		return
	move_and_collide(velocity * delta, true)
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is DisplaceableCharacterBody2D:
			var dir_to = global_position.direction_to(collider.global_position)
			var angle_to = dir_to.angle_to(velocity)
			var impulse = cos(angle_to) * dir_to * stat_component.get_current_mass() * velocity.length()
			collider.apply_impulse(impulse)
	move_and_slide()
