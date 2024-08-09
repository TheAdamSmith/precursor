class_name HealthComponent
extends Node2D

signal health_update(current_health, base_health, difference)

@export var stat_component : StatComponent
var _prev_full_health : float
var current_health : float


func _ready():
	if not stat_component.is_node_ready():
		await stat_component.ready
	current_health = _get_current_full_health()
	_prev_full_health = _get_current_full_health()
	# Current health is full health at this point
	health_update.emit(current_health, _get_current_full_health(), 0.0)
	stat_component.stat_updated.connect(_on_stat_updated)


func apply_damage(damage, damaging_entity = null):
	if current_health <= 0:
		return
	var damage_applied = min(current_health, damage)
	current_health -= damage_applied
	if current_health <= 0:
		current_health = 0
		EventService.entity_death.emit(damaging_entity, self)
	health_update.emit(current_health, _get_current_full_health(), -damage_applied)


func apply_healing(health, healing_entity = null):
	var healing_applied = min(_get_current_full_health() - current_health, health)
	current_health += healing_applied
	if current_health >= _get_current_full_health():
		current_health = _get_current_full_health()
	health_update.emit(current_health, _get_current_full_health(), healing_applied)


func _get_current_full_health():
	return stat_component.get_current_health()


func _on_stat_updated(stat_name):
	if stat_name != "health":
		return
	var health_diff = _get_current_full_health() - _prev_full_health
	_prev_full_health = _get_current_full_health()
	if health_diff > 0:
		apply_healing(health_diff)
		# Return because aplying healing will emit health_update
		return
	elif current_health > _get_current_full_health():
		current_health = _get_current_full_health()
	health_update.emit(current_health, _get_current_full_health(), health_diff)
