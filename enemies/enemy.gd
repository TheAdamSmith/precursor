extends CharacterBody2D
class_name Enemy

var speed = 100.0

# load nodes
@onready var player = get_node("/root/Level/playerv2")
@onready var animated_sprite = get_node("enemySprite")

# enemy properties
@export var contact_damage = 5.0
@export var experience_given = 10

# Attacks per second
@export var attack_speed = 1.0
var can_attack_timer : SceneTreeTimer

func _set_attack_animation_speed():
	
	var sprite_frames = animated_sprite.get_sprite_frames()
	var num_frames = sprite_frames.get_frame_count("attack")
	sprite_frames.set_animation_speed("attack", num_frames * attack_speed)

func give_experience():
	return experience_given

func _physics_process(delta):

	if not player:
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
		can_attack_timer = get_tree().create_timer(1 / attack_speed)
	elif not overlaps_player:
		animated_sprite.play("move")

	move_and_collide(velocity * delta)
