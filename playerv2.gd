extends CharacterBody2D
signal hit

@export var speed: int = 200 # Player speed
@onready var animations = $AnimationPlayer
var screen_size # size of game window

func _ready():
	screen_size = get_viewport_rect().size
	#to do: uncomment
	#hide()

func handleInput():
	var moveDirection = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = moveDirection * speed
func updateAnimation():
	if velocity.length() ==0:
		animations.stop()
	else:
		var direction = "Down"
		if velocity.x < 0: direction = "Left"
		elif velocity.x > 0: direction = "Right"
		elif velocity.y < 0: direction = "Up"
		
		animations.play("walk" + direction)
	
func _process(delta):
	handleInput()
	move_and_slide()
	updateAnimation()
	
func _on_body_entered(body):
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
