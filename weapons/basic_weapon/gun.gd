class_name Gun
extends Node2D

@onready var stat_component = $WeaponStatComponent
@export var bullet : PackedScene = preload("res://weapons/bullets/bullet.tscn")

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
		await get_tree().create_timer(1.0 / stat_component.get_current_fire_rate()).timeout
		can_fire = true


func _fire():
	# Basic fire method, can be overridden by subclass
	$Vfx.show()
	$Vfx.play()
	SoundManager.play_sfx(self, load("res://assets/audio/sfx/single_pistol_gunshot.mp3"), 0.5)
	var bullet_instance = _create_bullet()
	bullet_instance.damage = stat_component.get_current_bullet_damage()
	bullet_instance.set_z_index(1)
	bullet_instance.global_position = $BulletPoint.global_position
	bullet_instance.global_rotation = global_rotation
	bullet_instance.apply_impulse(Vector2(stat_component.get_current_bullet_speed(), 0).rotated(global_rotation))
	add_child(bullet_instance)
	can_fire = false
	$AnimationPlayer.play("recoil")


func _create_bullet():
	# Basic method, can be overridden by subclass
	var bullet_node = bullet.instantiate()
	bullet_node.piercing_num = stat_component.get_current_piercing_num()
	return bullet_node


func _on_vfx_animation_looped():
	$Vfx.hide()
	$Vfx.stop()
