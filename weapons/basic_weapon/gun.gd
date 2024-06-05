class_name Gun
extends Node2D

@export var fire_rate = 1.0
@export var bullet_speed = 1000.0
@export var bullet_damage = 10.0
@export var bullet : PackedScene = preload("res://weapons/basic_weapon/bullet.tscn")

var can_fire = true
var initial_rotation
var arena_group


func _ready():
	$Vfx.animation_looped.connect(_on_vfx_animation_looped)
	set_z_index(1)
	arena_group = ArenaUtilities.get_arena_name_by_position(global_position)
	initial_rotation = global_rotation
	if arena_group and arena_group not in get_groups():
		add_to_group(arena_group)


func _physics_process(delta):
	var enemy = ArenaUtilities.find_closest_in_arena_by_group(self, "enemy", arena_group)
	if enemy:
		var direction = (enemy.global_position - global_position)
		self.rotation = direction.angle()
	else:
		self.rotation = initial_rotation
	if can_fire:
		_fire()
		await get_tree().create_timer(fire_rate).timeout
		can_fire = true


func _fire():
	# Basic fire method, can be overridden by subclass
	$Vfx.show()
	$Vfx.play()
	SoundManager.play_sfx(self, load("res://assets/audio/sfx/single_pistol_gunshot.mp3"), -20)
	var bullet_instance = _create_bullet()
	bullet_instance.damage = bullet_damage
	bullet_instance.set_z_index(1)
	bullet_instance.global_position = $BulletPoint.global_position
	bullet_instance.global_rotation = global_rotation
	bullet_instance.apply_impulse(Vector2(bullet_speed, 0).rotated(global_rotation))
	add_child(bullet_instance)
	can_fire = false
	$AnimationPlayer.play("recoil")


func _create_bullet():
	# Basic method, can be overridden by subclass
	return bullet.instantiate()


func _on_vfx_animation_looped():
	$Vfx.hide()
	$Vfx.stop()
