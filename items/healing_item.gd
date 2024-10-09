class_name HealingItem
extends Item

@export var healing_value : float


func pickup(picking_up_entity):
	pass
 

func use(using_entity : Node2D):
	if not using_entity or not using_entity.has_node("HealthComponent"):
		return
	var health_component = using_entity.get_node("HealthComponent")
	health_component.apply_healing(healing_value)
