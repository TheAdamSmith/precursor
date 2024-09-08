class_name Player
extends DisplaceableCharacterBody2D

@onready var animations = $AnimationPlayer
@onready var audio_listener_2d : AudioListener2D = $AudioListener2D
@onready var marker2D = $Marker2D
@onready var sprite = $Marker2D/Cowboy
@onready var upgrade_component = $UpgradeComponent

@export var multiplayer_authority : int

var arena_group : String
var shader : ShaderMaterial
var flashing_timer : SceneTreeTimer
var intangible_timer : SceneTreeTimer


func _ready():
	if audio_listener_2d:
		# Audio listener not set for computer players
		audio_listener_2d.make_current()
	add_to_group("player")
	arena_group = ArenaUtilities.get_arena_name_by_position(global_position)
	add_to_group(arena_group)
	floor_snap_length = 0.0
	z_index = 2
	shader = sprite.material
	$HealthComponent.health_update.connect(_on_health_update)
	$HealthComponent.invulnerable.connect(_on_invulnerability_update)
	upgrade_component.initialize_stats()


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


func _on_invulnerability_update(invulnerable, duration_sec):
	if not invulnerable or duration_sec == 0.0:
		shader.set_shader_parameter("flashing", false)
		return
	shader.set_shader_parameter("flashing", true)
	shader.set_shader_parameter("flashing_start_time", float(Time.get_ticks_msec() * 1e-3))
	shader.set_shader_parameter("flashing_period_sec", 0.2)
	shader.set_shader_parameter("flashing_max_intensity", 0.5)
	shader.set_shader_parameter("flashing_blue", 1.0)
	shader.set_shader_parameter("flashing_green", 1.0)
	shader.set_shader_parameter("flashing_red", 1.0)


func set_intangible(duration_sec):
	if collision_mask & CollisionUtilities.ENEMY_MASK:
		collision_mask -= CollisionUtilities.ENEMY_MASK
	if collision_mask & CollisionUtilities.DAMAGE_MASK:
		collision_mask -= CollisionUtilities.DAMAGE_MASK
	intangible_timer = get_tree().create_timer(duration_sec)
	intangible_timer.timeout.connect(_on_intangibility_timeout)


func _on_intangibility_timeout():
	if !(collision_mask & CollisionUtilities.ENEMY_MASK):
		collision_mask += CollisionUtilities.ENEMY_MASK
	if !(collision_mask & CollisionUtilities.DAMAGE_MASK):
		collision_mask += CollisionUtilities.DAMAGE_MASK


func _on_health_update(current_health, base_health, difference):
	_flash_shader(difference)


func _flash_shader(health_diff):
	if not shader or health_diff == 0.0:
		return
	flashing_timer = get_tree().create_timer(0.5)
	flashing_timer.timeout.connect(_on_flashing_timeout)
	shader.set_shader_parameter("flashing", true)
	shader.set_shader_parameter("flashing_start_time", float(Time.get_ticks_msec() * 1e-3))
	shader.set_shader_parameter("flashing_period_sec", 0.5)
	shader.set_shader_parameter("flashing_max_intensity", 0.75)
	shader.set_shader_parameter("flashing_blue", 0.25)
	if health_diff > 0:
		shader.set_shader_parameter("flashing_green", 1.0)
		shader.set_shader_parameter("flashing_red", 0.25)
	else:
		shader.set_shader_parameter("flashing_green", 0.25)
		shader.set_shader_parameter("flashing_red", 1.0)


func _on_flashing_timeout():
	shader.set_shader_parameter("flashing", false)


func _physics_process(delta):
	velocity = move_direction * stat_component.get_current_speed()
	move_and_collide(velocity * delta, true)
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is DisplaceableCharacterBody2D:
			var dir_to = global_position.direction_to(collider.global_position)
			var angle_to = dir_to.angle_to(velocity)
			var impulse = cos(angle_to) * dir_to * stat_component.get_current_mass() * velocity.length()
			collider.apply_impulse(impulse)
	move_and_slide()
	update_animation()


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
