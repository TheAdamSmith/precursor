class_name GrenadeLauncher
extends Gun


func _create_bullet():
	var bullet_instance = bullet.instantiate()
	bullet_instance.aoe_damage = stat_component.get_current_aoe_damage()
	bullet_instance.aoe_scale = stat_component.get_current_aoe_scale()
	return bullet_instance
