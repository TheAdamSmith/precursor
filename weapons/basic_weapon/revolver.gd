extends Sprite2D

@export var fire_rate = 1
@export var bullet_speed = 1000

var bullet = preload("res://weapons/basic_weapon/bullet.tscn")
var can_fire = true
var initial_rotation


func _ready():
	initial_rotation = $Revolver.global_rotation
	set_z_index(1)


func _physics_process(delta):
	
	var enemy = find_closest_enemy($Revolver.global_position)
	
	if enemy:
		var direction = (enemy.global_position - $Revolver.global_position)
		self.rotation = direction.angle()
	else:
		self.rotation = initial_rotation
	
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


func find_closest_enemy(cur_pos):
	# big number idk if there is maxint in godot
	var closest_distance = 100000000
	var closest_enemy = null
	for enemy in get_tree().get_nodes_in_group("enemy"):
		var distance = enemy.global_transform.origin.distance_to(cur_pos)
		if distance < closest_distance:
			closest_distance = distance
			closest_enemy = enemy

	return closest_enemy
