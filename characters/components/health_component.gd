class_name HealthComponent
extends Node2D

signal health_update(current_health, base_health)

@export var base_health : float
var current_health : float


func _ready():
	current_health = base_health
	health_update.emit(current_health, base_health)


func apply_damage(damage, damaging_entity = null):
	current_health -= damage
	if current_health <= 0:
		current_health = 0
		EventService.entity_death.emit(damaging_entity, self)
	health_update.emit(current_health, base_health)


func apply_healing(health, healing_entity = null):
	current_health += health
	if current_health >= base_health:
		current_health = base_health
	health_update.emit()
