extends DisplaceableCharacterBody2D
class_name Enemy

signal attack_started
signal animation_change(animation : String)

@onready var animated_sprite = $AnimatedSprite2D
@export var upgrade_component : EnemyUpgradeComponent

# Attacks per second
var player : Player
var arena_group : String
var shader : ShaderMaterial
var flashing_timer : SceneTreeTimer


func _ready():
	add_to_group("enemy")
	arena_group = ArenaUtilities.get_arena_name_by_position(global_position)
	if arena_group and arena_group not in get_groups():
		add_to_group(arena_group)
	floor_snap_length = 0.0
	shader = animated_sprite.material
	upgrade_component.set_shader(shader)
	upgrade_component.set_enemy_shader_params()
	$HealthComponent.health_update.connect(_on_health_update)
	attack_started.connect(_on_attack_started)
	animation_change.connect(_on_animation_change)


func _on_animation_change(animation : String):
	animated_sprite.play(animation)


func _on_attack_started():
	_set_attack_animation_speed()
	animated_sprite.play("attack")


func _set_attack_animation_speed():
	var sprite_frames : SpriteFrames = animated_sprite.get_sprite_frames()
	var num_frames = sprite_frames.get_frame_count("attack")
	sprite_frames.set_animation_speed("attack", num_frames * stat_component.get_current_attacks_per_sec())
	sprite_frames.set_animation_loop("attack", false)


func _on_health_update(current_health, base_health, difference):
	call_deferred("_flash_shader", difference)


func _flash_shader(health_diff):
	if not shader or health_diff == 0.0 or $HealthComponent.is_full_health():
		return
	flashing_timer = get_tree().create_timer(0.5, false, true)
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


func on_death():
	remove_from_group("enemy")
	if $AnimationPlayer:
		#for child in get_children():
			#if child is CollisionShape2D or child is StateMachine:
				#child.queue_free()
		collision_layer = 0
		collision_mask = 0
		set_physics_process(false)
		$AnimationPlayer.play("death")
		await $AnimationPlayer.animation_finished
	TreeUtilities.reparent_bullets(self, get_tree().current_scene)
	queue_free()


func give_experience():
	return stat_component.get_current_experience_given()


func _physics_process(delta):
	scale = Vector2(stat_component.get_current_scale(), stat_component.get_current_scale())
	max_speed = stat_component.get_current_speed()
	accelerate_and_collide(delta)
	if move_direction.x > 0:
		animated_sprite.set_flip_h(true)
	elif move_direction.x < 0:
		animated_sprite.set_flip_h(false)
	if animated_sprite.animation != "move" and animated_sprite.is_playing():
		return
	animated_sprite.play("move")
