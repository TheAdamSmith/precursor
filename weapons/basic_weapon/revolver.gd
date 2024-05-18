class_name Revolver
extends Node2D

@export var fire_rate = 1
@export var bullet_speed = 1000

var bullet = preload("res://weapons/basic_weapon/bullet.tscn")
var can_fire = true
var initial_rotation
var arena_group


func _ready():
	initial_rotation = $Revolver.global_rotation
	set_z_index(1)
	arena_group = ArenaUtilities.get_arena_name_by_position(global_position)
	if arena_group and arena_group not in get_groups():
		add_to_group(arena_group)


func _physics_process(delta):
	var enemy = ArenaUtilities.find_closest_in_arena_by_group(self, "enemy", arena_group)
	if enemy:
		var direction = (enemy.global_position - $Revolver.global_position)
		self.rotation = direction.angle()
	else:
		self.rotation = initial_rotation
	
	if can_fire:
		$Vfx.show()
		$Vfx.play()
		SoundManager.play_sfx(self, load("res://assets/audio/sfx/single_pistol_gunshot.mp3"), -20)
		var bullet_instance = bullet.instantiate()
		bullet_instance.set_z_index(0)
		bullet_instance.position = $BulletPoint.position
		bullet_instance.rotation = $Revolver.rotation
		bullet_instance.apply_impulse(Vector2(bullet_speed, 0).rotated($Revolver.global_rotation))
		add_child(bullet_instance)
		can_fire = false
		$AnimationPlayer.play("recoil")
		await get_tree().create_timer(fire_rate).timeout
		can_fire = true


func _on_vfx_animation_looped():
	$Vfx.hide()
	$Vfx.stop()
