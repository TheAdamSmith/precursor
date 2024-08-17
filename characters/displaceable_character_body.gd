class_name DisplaceableCharacterBody2D
extends CharacterBody2D

@export var mass : float = 1.0
@export var acceleration_after_displacement = 500.0
@export var max_speed : float
@export var max_displaced_speed : float
@export var displaced_duration_sec = 1.0
var displaced = false
var displaced_timer : SceneTreeTimer


var move_direction : Vector2 = Vector2.ZERO :
	set(dir):
		move_direction = dir.normalized()
	get:
		return move_direction


func apply_impulse(impulse_vec : Vector2, displace_duration : float):
	velocity += impulse_vec / mass
	if not displaced:
		displaced_timer = get_tree().create_timer(displaced_duration_sec)
	displaced = true


func accelerate_and_collide(delta):
	if displaced:
		var tmp_move_dir = move_direction if move_direction != Vector2.ZERO else -velocity.normalized()
		velocity += move_direction * acceleration_after_displacement * delta
	if displaced and velocity.length() >= max_displaced_speed:
		velocity = velocity.normalized() * max_displaced_speed
	if not displaced or displaced_timer.time_left == 0.0:
		displaced = false
		velocity = move_direction * max_speed
	if not displaced:
		move_and_slide()
		return
	move_and_collide(velocity * delta, true)
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is DisplaceableCharacterBody2D:
			var dir_to = global_position.direction_to(collider.global_position)
			var angle_to = dir_to.angle_to(velocity)
			var impulse = cos(angle_to) * dir_to * mass * velocity.length()
			collider.apply_impulse(impulse)
	move_and_slide()
