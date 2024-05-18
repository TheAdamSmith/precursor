class_name UpgradeInputComponent
extends Node2D

@export var upgrade_component : UpgradeComponent


func _unhandled_input(event):
	var upgrade_vec
	if event.is_action_pressed("up_upgrade"):
		upgrade_vec = Vector2i.UP
	elif event.is_action_pressed("down_upgrade"):
		upgrade_vec = Vector2i.DOWN
	elif event.is_action_pressed("right_upgrade"):
		upgrade_vec = Vector2i.RIGHT
	elif event.is_action_pressed("left_upgrade"):
		upgrade_vec = Vector2i.LEFT
	else:
		return
	upgrade_component.upgrade_input.emit(upgrade_vec)
