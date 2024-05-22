class_name Player
extends CharacterBody2D

@onready var animations = $AnimationPlayer
@onready var audio_listener_2d: AudioListener2D = $AudioListener2D
@onready var marker2D=$Marker2D
var arena_group : String


func _ready():
	if audio_listener_2d:
		# Audio listener not set for computer players
		audio_listener_2d.make_current()
	add_to_group("player")
	arena_group = ArenaUtilities.get_arena_name_by_position(global_position)
	add_to_group(arena_group)
	floor_snap_length = 0.0
	z_index = 2


func update_animation():
	if velocity.length() == 0:
		animations.play("idle")
	else:
		marker2D.scale.x = sign(velocity.x) if velocity.x != 0 else marker2D.scale.x
		animations.play("walk")


func _physics_process(delta):
	move_and_slide()
	update_animation()


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
