class_name BuffItem
extends Item

@export var buff_duration_sec = 0.0
 

func use(using_entity : Node2D):
	if not using_entity or not using_entity.has_node("StatComponent"):
		return
	var stat_component = using_entity.get_node("StatComponent")
	stat_component.register_temp_multiplier("scale", 1.5, 10.0)
	stat_component.register_temp_multiplier("mass", 1.5, 10.0)
	stat_component.register_temp_multiplier("speed", 1.5, 10.0)
	var health_component = using_entity.get_node("HealthComponent")
	health_component.set_invulnerable(buff_duration_sec)
