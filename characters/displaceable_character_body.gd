class_name DisplaceableCharacterBody2D
extends CharacterBody2D

@export var mass : float
@export var movement_acceleration : float


var move_direction : Vector2 = Vector2.ZERO :
	set(dir):
		move_direction = dir.normalized()
	get:
		return move_direction


func apply_impulse(impulse_vec : Vector2):
	velocity += impulse_vec / mass


func _physics_process(delta):
	velocity += move_direction * movement_acceleration * delta
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		print("Collided with: ", collision.get_collider())

