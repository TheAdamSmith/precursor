extends CharacterBody2D

var health = 3

# TODO modify once mobs are generated via script, 
# should not be hard coding to find the file
@onready var player = get_node("/root/Level/player")
@onready var _animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 100.0
	
	#check to see how many objects colliding with the mob
	var overlaps = %AttackBox.get_overlapping_bodies()
	if (overlaps.has(player)):
		_animated_sprite.play("attack")
	else :
		_animated_sprite.play("move")
	
	move_and_slide()

func take_damage():
	health -= 1
