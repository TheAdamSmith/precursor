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
	for body in get_overlapping_bodies():
		_on_body_entered(body)


func set_inactive():
	ability_active = false


func _on_body_entered(body):
	if not ability_active:
		return
	EventService.entity_damaged.emit(self, body, ability_stat_component.get_current_damage())
	if ability_stat_component.get_current_knockback_impulse_scalar() != 0.0 and body is DisplaceableCharacterBody2D:
		var dir_to = global_position.direction_to(body.global_position)
		var impulse = dir_to * ability_stat_component.get_current_knockback_impulse_scalar()
		body.apply_impulse(impulse, ability_stat_component.get_current_knockback_max_speed_mult())
	if ability_stat_component.get_current_stun_duration_sec():
		pass
