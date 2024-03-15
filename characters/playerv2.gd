extends CharacterBody2D
signal hit

@export var speed: int = 200 # Player speed
@onready var animations = $AnimationPlayer
@onready var audio_listener_2d: AudioListener2D = $AudioListener2D
var screen_size # size of game window


func _ready():
	print("Player is ready")
	screen_size = get_viewport_rect().size
	audio_listener_2d.make_current()
	SoundManager.play_bgm(load("res://assets/audio/bgm/smash mouth - all star.wav"))
	#to do: uncomment
	#hide()


func handleInput():
	var moveDirection = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down",
	)
	velocity = moveDirection * speed


func updateAnimation():
	var x_mov = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_mov = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	var mov = Vector2(x_mov, y_mov)
	
	if mov.length() ==0:
		animations.stop()
	else:
		var direction = "Down"
		if mov.x < 0: direction = "Left"
		elif mov.x > 0: direction = "Right"
		elif mov.y < 0: direction = "Up"
		
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

