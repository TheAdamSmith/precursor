extends CharacterBody2D
class_name RoosterBoss

var speed = 150.0
var attackAnimation = ["laser"]

@onready var player = get_node("/root/Level/playerv2")
@onready var animation = get_node("AnimatedSprite2D")
#@onready var roosterBoss = get_node("/root/Level/roosterBoss")
@onready var spawned = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not spawned: 
		animation.play("spawn")
		await animation.animation_finished
		spawned = true
	else:
		animation.play("idle")
		var direction = global_position.direction_to(player.global_position)
		
		if direction.x > 0:
			animation.set_flip_h(true)
		else :
			animation.set_flip_h(false)
		
		velocity = direction * speed
		move_and_slide()
		

		
