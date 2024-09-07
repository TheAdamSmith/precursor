class_name AttackComponenent
extends Node2D

@export var stat_component : CharacterStatComponent

var enemy : Enemy
var enabled = false
var can_attack = false
var attack_cooldown_timer : SceneTreeTimer


func _physics_process(delta):
	if not enabled:
		return
	if not attack_cooldown_timer or attack_cooldown_timer.time_left == 0.0:
		can_attack = true
	if not can_attack:
		return
	_attack()
	if enemy:
		enemy.attack_started.emit()
	attack_cooldown_timer = get_tree().create_timer(1.0 / stat_component.get_current_attacks_per_sec())
	can_attack = false


func _attack():
	# Should be defined by subclasses
	pass
