class_name Item
extends Node2D

@export var pickup_on_contact = true
@export var use_on_pickup = true
@export var free_on_pickup = true
@export var lifetime_on_ground_sec = INF

var lifetime_timer : SceneTreeTimer


func _ready():
	if lifetime_on_ground_sec > 0.0 and lifetime_on_ground_sec != INF:
		lifetime_timer = get_tree().create_timer(lifetime_on_ground_sec)
		lifetime_timer.timeout.connect(_on_lifetime_timeout)
	if pickup_on_contact:
		$Area2D.body_entered.connect(_on_pickup)
	if $AnimationPlayer:
		$AnimationPlayer.play("idle")


func _on_pickup(body):
	if not pickup(body):
		return
	if use_on_pickup:
		use(body)
	if free_on_pickup:
		queue_free()


func _on_lifetime_timeout():
	queue_free()


func pickup(picking_up_entity) -> bool:
	return true


func use(using_entity) -> void:
	pass
