extends CharacterBody2D
signal hit

@export var speed: int = 200 # Player speed
@onready var animations = $AnimationPlayer
@onready var audio_listener_2d: AudioListener2D = $AudioListener2D
@onready var marker2D=$Marker2D
var screen_size # size of game window


func _ready():
	screen_size = get_viewport_rect().size
	audio_listener_2d.make_current()
	#to do: uncomment
	#hide()


func handle_input():
	var moveDirection = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down",
	)
	velocity = moveDirection * speed


func update_animation():
	var x_mov = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_mov = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	var mov = Vector2(x_mov, y_mov)

	if x_mov > 0:
		marker2D.scale.x = 1
	elif x_mov < 0:
		marker2D.scale.x = -1

	if mov.length() == 0:
		animations.play("idle")
	else:
		animations.play("walk")


func _physics_process(delta):
	handle_input()
	move_and_collide(velocity * delta)
	update_animation()


func _on_body_entered(body):
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

