class_name MeleeAttackComponenent
extends AttackComponenent

@export var attack_box : Area2D


func _attack():
	for body in attack_box.get_overlapping_bodies():
		if body is Player:
			EventService.entity_damaged.emit(self, body, stat_component.get_current_damage())
