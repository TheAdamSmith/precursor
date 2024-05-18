extends CharacterBody2D
class_name Enemy

var speed = 100.0

@onready var animated_sprite = get_node("enemySprite")

# enemy properties
@export var contact_damage = 5.0
@export var experience_given = 10

# Attacks per second
@export var attack_speed = 1.0
var player : Player
var arena_group : String
var can_attack_timer : SceneTreeTimer


func _ready():
	add_to_group("enemy")
	arena_group = ArenaUtilities.get_arena_name_by_position(global_position)
	if arena_group and arena_group not in get_groups():
		add_to_group(arena_group)
	floor_snap_length = 0.0

func _set_attack_animation_speed():
	var sprite_frames = animated_sprite.get_sprite_frames()
	var num_frames = sprite_frames.get_frame_count("attack")
	sprite_frames.set_animation_speed("attack", num_frames * attack_speed)


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
		
	velocity = direction * speed

	# check to see how many objects colliding with the mob
	# play attack animation on collision
	var overlaps = get_node("AttackBox").get_overlapping_bodies()
	var overlaps_player = overlaps.has(player)
	if overlaps_player and (not can_attack_timer or can_attack_timer.time_left == 0):
		EventService.entity_damaged.emit(self, player, contact_damage)
		_set_attack_animation_speed()
		animated_sprite.play("attack")
		SoundManager.play_sfx(self, load("res://assets/audio/sfx/hit.wav"))
		can_attack_timer = get_tree().create_timer(1 / attack_speed)
	elif not overlaps_player:
		animated_sprite.play("move")
	move_and_slide()
