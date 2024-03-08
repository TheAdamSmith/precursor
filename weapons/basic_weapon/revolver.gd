extends Sprite2D

@export var fire_rate = 3
@export var bullet_speed = 1000

var bullet = preload("res://weapons/basic_weapon/bullet.tscn")
var can_fire = true


# Called when the node enters the scene tree for the first time.
func _ready():
	print("revolver is ready")
	set_z_index(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if can_fire:
		$Vfx.show()
		$Vfx.play()
		var bullet_instance = bullet.instantiate()
		bullet_instance.set_z_index(0)
		bullet_instance.position = $BulletPoint.get_global_position()
		bullet_instance.rotation = $Revolver.global_rotation
		bullet_instance.apply_impulse(Vector2(bullet_speed, 0).rotated($Revolver.global_rotation))
		get_tree().get_root().add_child(bullet_instance)
		can_fire = false
		await get_tree().create_timer(fire_rate).timeout
		can_fire = true

func _on_vfx_animation_looped():
	$Vfx.hide()
	$Vfx.stop()
