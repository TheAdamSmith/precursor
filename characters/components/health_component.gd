class_name HealthComponent
extends Node2D

signal health_update(current_health, base_health)

@export var stats : StatResource
var base_health
var current_health


func _ready():
	await stats
	base_health = stats._get_base_stat(StatResource.names.HEALTH)
	current_health = base_health
	health_update.emit()


func apply_damage(damage):
	current_health -= damage
	if current_health <= 0:
		current_health = 0
	health_update.emit()


func apply_healing(health):
	current_health += health
	if current_health >= base_health:
		current_health = base_health
	health_update.emit()


func increase_
