class_name Shotgun
extends Gun

@export var bullet_spread_deg = 25.0


func _ready():
	super._ready()
	$Vfx.animation_looped.connect(_on_vfx_animation_looped)


func _fire():
	$Vfx.show()
	$Vfx.play()
	SoundManager.play_sfx(self, load("res://assets/audio/sfx/single_pistol_gunshot.mp3"), 0.5)
	var bullet_points = $BulletPoints.get_children()
	var angle_per_bullet = bullet_spread_deg / bullet_points.size()
	for i in bullet_points.size():
		var bullet_instance = bullet.instantiate()
		bullet_instance.damage = stat_component.get_current_bullet_damage()
		bullet_instance.set_z_index(1)
		bullet_instance.global_position = bullet_points[i].global_position
		var angle_adjustment = deg_to_rad(bullet_spread_deg / 2.0 - i * angle_per_bullet)
		bullet_instance.global_rotation = global_rotation + angle_adjustment
		bullet_instance.apply_impulse(Vector2(stat_component.get_current_bullet_speed(), 0).rotated(global_rotation + angle_adjustment))
		add_child(bullet_instance)
		can_fire = false
	$AnimationPlayer.play("recoil")


func _on_vfx_animation_looped():
	$Vfx.hide()
	$Vfx.stop()
