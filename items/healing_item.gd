class_name HealingItem
extends Item

@export var healing_value : float
@export var invulnerability_time_sec = 0.0


func pickup(body):
	if not body or not body.has_node("HealthComponent"):
		return false
	var health_component = body.get_node("HealthComponent")
	return not health_component.is_full_health()


func use(using_entity : Node2D):
	if not using_entity or not using_entity.has_node("HealthComponent"):
		return
	var health_component = using_entity.get_node("HealthComponent")
	if invulnerability_time_sec > 0.0:
		health_component.set_invulnerable(invulnerability_time_sec)
	health_component.apply_healing(healing_value)
