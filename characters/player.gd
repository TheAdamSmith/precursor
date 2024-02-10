extends CharacterBody2D
signal hit

@export var speed = 400 # Player speed
var screen_size # size of game window

func _ready():
	screen_size = get_viewport_rect().size
	#to do: uncomment
	#hide()

func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	#movement and animation
	if Input.is_action_pressed("move_right"):
		$AnimatedSprite2D.rotation = PI/2
		$CollisionShape2D.rotation = PI/2
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		$AnimatedSprite2D.rotation = 3*PI/2
		$CollisionShape2D.rotation = 3*PI/2
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		$AnimatedSprite2D.rotation = PI
		$CollisionShape2D.rotation = PI
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		$AnimatedSprite2D.rotation = 0
		$CollisionShape2D.rotation = PI
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	move_and_collide(velocity * delta)

func _on_body_entered(body):
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
