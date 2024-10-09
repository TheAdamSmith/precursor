class_name Item
extends Node2D

@export var pickup_on_contact = true
@export var use_on_pickup = true
@export var free_on_pickup = true


func _ready():
	if pickup_on_contact:
		$Area2D.body_entered.connect(_on_pickup)


func _on_pickup(body):
	pickup(body)
	if use_on_pickup:
		use(body)
	if free_on_pickup:
		queue_free()


func pickup(picking_up_entity):
	pass


func use(using_entity):
	pass
