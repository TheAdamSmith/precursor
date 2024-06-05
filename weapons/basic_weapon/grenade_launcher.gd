class_name GrenadeLauncher
extends Gun

@export var aoe_damage = 40.0


func _create_bullet():
	var bullet_instance = bullet.instantiate()
	bullet_instance.aoe_damage = aoe_damage
	return bullet_instance
