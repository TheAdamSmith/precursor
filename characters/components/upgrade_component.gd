class_name UpgradeComponent
extends Node2D


signal upgrade_input(upgrade_vec)

@export var experience_component : ExperienceComponent
var upgrade_count = 1


func _ready():
	experience_component.level_update.connect(_on_level_update)
	upgrade_input.connect(_handle_upgrade_input)
	show()


func _on_level_update(level):
	show()
	upgrade_count += 1


func _handle_upgrade_input(upgrade_vec):
	if upgrade_count == 0:
		return

	var upgrade_rotation
	var y_scale
	if upgrade_vec == Vector2i.UP:
		upgrade_rotation = -PI / 2
		y_scale = 1
	elif upgrade_vec == Vector2i.DOWN:
		upgrade_rotation = PI / 2
		y_scale = 1
	elif upgrade_vec == Vector2i.RIGHT:
		upgrade_rotation = 0
		y_scale = 1
	elif upgrade_vec == Vector2i.LEFT:
		upgrade_rotation = PI
		y_scale = -1
	else:
		return
	var upgrade_scene = load("res://weapons/basic_weapon/shotgun.tscn")
	var upgrade_node = upgrade_scene.instantiate()
	upgrade_node.position = upgrade_vec * 35
	upgrade_node.rotation = upgrade_rotation
	upgrade_node.scale.y = y_scale
	get_parent().add_child(upgrade_node)
	upgrade_count -= 1
	if upgrade_count == 0:
		hide()
