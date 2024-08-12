extends CharacterBody2D
class_name Enemy

@onready var animated_sprite = get_node("enemySprite")
@onready var stat_component = $StatComponent

# enemy properties
@export var experience_given = 0.22

# Attacks per second
var player : Player
var arena_group : String
var can_attack_timer : SceneTreeTimer
var shader : ShaderMaterial
var flashing_timer : SceneTreeTimer


func _ready():
	add_to_group("enemy")
	arena_group = ArenaUtilities.get_arena_name_by_position(global_position)
	if arena_group and arena_group not in get_groups():
		add_to_group(arena_group)
	floor_snap_length = 0.0
	shader = animated_sprite.material
	$HealthComponent.health_update.connect(_on_health_update)


func _set_attack_animation_speed():
	var sprite_frames = animated_sprite.get_sprite_frames()
	var num_frames = sprite_frames.get_frame_count("attack")
	sprite_frames.set_animation_speed("attack", num_frames * stat_component.get_current_attacks_per_sec())


func _on_health_update(current_health, base_health, difference):
	call_deferred("_flash_shader", difference)


func _flash_shader(health_diff):
	if not shader or health_diff == 0.0 or $HealthComponent.is_full_health():
		return
	flashing_timer = get_tree().create_timer(0.5)
	flashing_timer.timeout.connect(_on_flashing_timeout)
	shader.set_shader_parameter("flashing", true)
	shader.set_shader_parameter("flashing_start_time", float(Time.get_ticks_msec() * 1e-3))
	shader.set_shader_parameter("flashing_period_sec", 0.5)
	shader.set_shader_parameter("flashing_max_intensity", 0.5)
	shader.set_shader_parameter("flashing_blue", 0.0)
	if health_diff > 0:
		shader.set_shader_parameter("flashing_green", 1.0)
		shader.set_shader_parameter("flashing_red", 0.0)
	else:
		shader.set_shader_parameter("flashing_green", 0.0)
		shader.set_shader_parameter("flashing_red", 1.0)


func _on_flashing_timeout():
	shader.set_shader_parameter("flashing", false)


func give_experience():
	return experience_given


func _find_player():
	player = ArenaUtilities.find_closest_in_arena_by_group(self, "player", arena_group)


func _physics_process(delta):
	if not player and not _find_player():
		return
	if not is_instance_valid(player):
		return
	var direction = global_position.direction_to(player.global_position)
	# flip the animated sprite body in the direction of travel
	if direction.x > 0:
		animated_sprite.set_flip_h(true)
	else :
		animated_sprite.set_flip_h(false)
	velocity = direction * stat_component.get_current_speed()

	# check to see how many objects colliding with the mob
	# play attack animation on collision
	var overlaps = get_node("AttackBox").get_overlapping_bodies()
	var overlaps_player = overlaps.has(player)
	if overlaps_player and (not can_attack_timer or can_attack_timer.time_left == 0):
		EventService.entity_damaged.emit(self, player, stat_component.get_current_damage())
		_set_attack_animation_speed()
		animated_sprite.play("attack")
		SoundManager.play_sfx(self, load("res://assets/audio/sfx/hit.wav"))
		can_attack_timer = get_tree().create_timer(1 / stat_component.get_current_attacks_per_sec())
	elif not overlaps_player:
		animated_sprite.play("move")
	move_and_slide()
