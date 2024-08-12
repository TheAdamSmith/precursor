class_name AbilityDamageComponent
extends Area2D

@export var ability_stat_component : DashStatComponent

var ability_active = false


func _ready():
	body_entered.connect(_on_body_entered)
	ability_stat_component.stat_updated.connect(_on_stat_update)
	scale.x = ability_stat_component.get_current_aoe_scale()
	scale.y = ability_stat_component.get_current_aoe_scale()


func _on_stat_update(stat_name):
	if stat_name != "aoe_scale":
		return
	scale.x = ability_stat_component.get_current_aoe_scale()
	scale.y = ability_stat_component.get_current_aoe_scale()


func set_active():
	ability_active = true


func set_inactive():
	ability_active = false


func _on_body_entered(body):
	if not ability_active:
		return
	EventService.entity_damaged.emit(self, body, ability_stat_component.get_current_damage())
