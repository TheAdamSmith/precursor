class_name DisplaceableCharacterBody2D
extends CharacterBody2D

@export var mass : float = 1.0
@export var acceleration_after_displacement : float = 500
@export var max_velocity : float
var displaced = false


var move_direction : Vector2 = Vector2.ZERO :
	set(dir):
		move_direction = dir.normalized()
	get:
		return move_direction


func apply_impulse(impulse_vec : Vector2):
	velocity += impulse_vec / mass
	displaced = true
	#call_deferred("_set_displaced_velocity", impulse_vec)


func _set_displaced_velocity(impulse_vec : Vector2):
	velocity += impulse_vec / mass
	displaced = true
	if self is Enemy:
		print("Velocity after displacement:",velocity)


func accelerate_and_collide(delta):
	if displaced:
		if self is Enemy:
			print("Velocity before accel:",velocity)
		var tmp_move_dir = move_direction if move_direction != Vector2.ZERO else -velocity.normalized()
		velocity += move_direction * acceleration_after_displacement * delta
	if (velocity.length() >= max_velocity and move_direction.angle_to(velocity) < PI / 8)  or not displaced:
		displaced = false
		velocity = move_direction * max_velocity
	move_and_collide(velocity * delta, true)
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is DisplaceableCharacterBody2D:
			var impulse = global_position.direction_to(collider.global_position) * mass * velocity.length()
			collider.apply_impulse(impulse)
	if self is Enemy and displaced:
		print("Velocity before slide:",velocity)
	move_and_slide()
	if self is Enemy and displaced:
		print("Velocity after slide:",velocity)
