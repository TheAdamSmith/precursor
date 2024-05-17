class_name Player
extends CharacterBody2D

@onready var animations = $AnimationPlayer
@onready var audio_listener_2d: AudioListener2D = $AudioListener2D
var arena_group : String


func _ready():
	if audio_listener_2d:
		# Audio listener not set for computer players
		audio_listener_2d.make_current()
	add_to_group("player")
	arena_group = ArenaUtilities.get_arena_name_by_position(global_position)
	add_to_group(arena_group)
	floor_snap_length = 0.0


func update_animation():
	# Velocity should be set in an input component
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
	move_and_slide()
	update_animation()


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

