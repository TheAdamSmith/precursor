class_name Item
extends Node2D

@export var pickup_on_contact = true
@export var use_on_pickup = true


func _ready():
	pass


func _on_pickup():
	pickup()
	if use_on_pickup:
		use()


func pickup():
	pass


func use():
	pass
