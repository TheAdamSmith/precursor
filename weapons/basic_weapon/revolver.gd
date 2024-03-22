extends Sprite2D

@export var fire_rate = 1
@export var bullet_speed = 1000

var bullet = preload("res://weapons/basic_weapon/bullet.tscn")
var can_fire = true


func _ready():
	set_z_index(1)


func _physics_process(delta):
	if can_fire:
		$Vfx.show()
		$Vfx.play()
		var bullet_instance = bullet.instantiate()
		bullet_instance.set_z_index(0)
		bullet_instance.position = $BulletPoint.position
		bullet_instance.rotation = $Revolver.rotation
		bullet_instance.apply_impulse(Vector2(bullet_speed, 0).rotated($Revolver.global_rotation))
		add_child(bullet_instance)
		can_fire = false
		await get_tree().create_timer(fire_rate).timeout
		can_fire = true


func _on_vfx_animation_looped():
	$Vfx.hide()
	$Vfx.stop()
