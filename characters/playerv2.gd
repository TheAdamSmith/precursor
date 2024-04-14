class_name Player
extends CharacterBody2D

@onready var animations = $AnimationPlayer


func _ready():
	add_to_group("Player")
	print(self)
	print(get_groups())


func update_animation():
	if velocity.length() == 0:
		animations.stop()
	else:
		var direction
		if abs(velocity.x) > abs(velocity.y):
			direction = "Right" if velocity.x > 0 else "Left"
		else:
			direction = "Up" if velocity.y < 0 else "Down"
		animations.play("walk" + direction)


func _physics_process(delta):
	move_and_collide(velocity * delta)
	update_animation()


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

