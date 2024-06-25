class_name HealthComponent
extends Node2D

signal health_update(current_health, base_health)

@export var stat_component : StatComponent
var _prev_full_health : float
var current_health : float


func _ready():
	if not stat_component.is_node_ready():
		await stat_component.ready
	current_health = _get_current_full_health()
	_prev_full_health = _get_current_full_health()
	# Current health is full health at this point
	health_update.emit(current_health, _get_current_full_health())
	stat_component.stat_updated.connect(_on_stat_updated)


func apply_damage(damage, damaging_entity = null):
	if current_health <= 0:
		return
	current_health -= damage
	if current_health <= 0:
		current_health = 0
		EventService.entity_death.emit(damaging_entity, self)
	health_update.emit(current_health, _get_current_full_health())


func apply_healing(health, healing_entity = null):
	current_health += health
	if current_health >= _get_current_full_health():
		current_health = _get_current_full_health()
	health_update.emit(current_health, _get_current_full_health())


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
	health_update.emit(current_health, _get_current_full_health())
