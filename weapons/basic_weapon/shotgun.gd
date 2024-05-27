class_name Shotgun
extends Node2D

@export var fire_rate = 2
@export var bullet_speed = 600
@export var bullet_spread_deg = 25.0

var bullet = preload("res://weapons/basic_weapon/bullet.tscn")
var can_fire = true
var initial_rotation
var arena_group


func _ready():
	initial_rotation = $Sprite2D.global_rotation
	set_z_index(1)
	arena_group = ArenaUtilities.get_arena_name_by_position(global_position)
	if arena_group and arena_group not in get_groups():
		add_to_group(arena_group)


func _physics_process(delta):
	var enemy = ArenaUtilities.find_closest_in_arena_by_group(self, "enemy", arena_group)
	if enemy:
		var direction = (enemy.global_position - $Sprite2D.global_position)
		self.rotation = direction.angle()
	else:
		self.rotation = initial_rotation
	
	if can_fire:
		$Vfx.show()
		$Vfx.play()
		SoundManager.play_sfx(self, load("res://assets/audio/sfx/single_pistol_gunshot.mp3"), -20)
		var bullet_points = $BulletPoints.get_children()
		var angle_per_bullet = bullet_spread_deg / bullet_points.size()
		for i in bullet_points.size():
			var bullet_instance = bullet.instantiate()
			bullet_instance.damage = 5
			bullet_instance.set_z_index(0)
			bullet_instance.position = bullet_points[i].position
			var angle_adjustment = deg_to_rad(bullet_spread_deg / 2.0 - i * angle_per_bullet)
			bullet_instance.rotation = $Sprite2D.rotation + angle_adjustment
			bullet_instance.apply_impulse(Vector2(bullet_speed, 0).rotated($Sprite2D.global_rotation + angle_adjustment))
			add_child(bullet_instance)
			can_fire = false
		$AnimationPlayer.play("recoil")
		await get_tree().create_timer(fire_rate).timeout
		can_fire = true


func _on_vfx_animation_looped():
	$Vfx.hide()
	$Vfx.stop()
