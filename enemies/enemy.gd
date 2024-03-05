extends CharacterBody2D

var health = 3
var speed = 100.0

# TODO modify once mobs are generated via script, 
# should not be hard coding to find the file
@onready var player = get_node("/root/Level/playerv2")
@onready var _animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	
	var direction = global_position.direction_to(player.global_position)
	
	# flip the animated sprite body in the direction of travel
	if direction.x > 0:
		_animated_sprite.set_scale(Vector2(-1, 1))
	else :
		_animated_sprite.set_scale(Vector2(1, 1))
	
	velocity = direction * speed
	
	# check to see how many objects colliding with the mob
	# play attack animation on collision
	var overlaps = %AttackBox.get_overlapping_bodies()
	if (overlaps.has(player)):
		_animated_sprite.play("attack")
	else :
		_animated_sprite.play("move")
	
	move_and_slide()

func take_damage():
	health -= 1
