class_name Player
extends CharacterBody2D

@onready var animations = $AnimationPlayer
@onready var audio_listener_2d : AudioListener2D = $AudioListener2D
@onready var marker2D = $Marker2D
@onready var sprite = $Marker2D/Cowboy
@export var multiplayer_authority : int

var arena_group : String
var move_direction : Vector2 = Vector2.ZERO
var flashing_shader : ShaderMaterial


func _ready():
	if audio_listener_2d:
		# Audio listener not set for computer players
		audio_listener_2d.make_current()
	add_to_group("player")
	arena_group = ArenaUtilities.get_arena_name_by_position(global_position)
	add_to_group(arena_group)
	floor_snap_length = 0.0
	z_index = 2
	flashing_shader = sprite.material
	$HealthComponent.health_update.connect(_on_health_update)


@rpc("any_peer", "call_local", "reliable")
func set_initial_values(pos, multiplayer_authority):
	position = pos
	set_multiplayer_authority(multiplayer_authority, true)
	set_process(is_multiplayer_authority())
	set_process_input(is_multiplayer_authority())
	if is_multiplayer_authority():
		audio_listener_2d.make_current()


func update_animation():
	if velocity.length() == 0:
		animations.play("idle")
	else:
		marker2D.scale.x = sign(velocity.x) if velocity.x != 0 else marker2D.scale.x
		animations.play("walk")


func _on_health_update(current_health, base_health, difference):
	_flash_shader(difference)


func _flash_shader(health_diff):
	if not flashing_shader or health_diff == 0.0:
		return
	flashing_shader.set_shader_parameter("start_time", float(Time.get_ticks_msec() * 1e-3))
	flashing_shader.set_shader_parameter("num_cycles", 0.5)
	flashing_shader.set_shader_parameter("period_sec", 0.5)
	flashing_shader.set_shader_parameter("intensity", 0.75)
	flashing_shader.set_shader_parameter("blue", 0.25)
	if health_diff > 0:
		flashing_shader.set_shader_parameter("green", 1.0)
		flashing_shader.set_shader_parameter("red", 0.25)
	else:
		flashing_shader.set_shader_parameter("green", 0.25)
		flashing_shader.set_shader_parameter("red", 1.0)


func _physics_process(delta):
	velocity = move_direction * stat_component.get_current_speed()
	move_and_slide()
	update_animation()


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
