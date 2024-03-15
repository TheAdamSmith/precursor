class_name UpgradeComponent
extends Node2D


@export var experience_component : ExperienceComponent
var upgrade_count = 1


func _ready():
	experience_component.level_update.connect(_on_level_update)
	show()


func _on_level_update(level):
	show()
	upgrade_count += 1


func _unhandled_input(event):
	if upgrade_count == 0:
		return
	var upgrade_vec
	var upgrade_rotation
	var y_scale
	if Input.is_action_just_pressed("up_upgrade"):
		upgrade_vec = Vector2.UP
		upgrade_rotation = -PI / 2
		y_scale = 1
	elif Input.is_action_just_pressed("down_upgrade"):
		upgrade_vec = Vector2.DOWN
		upgrade_rotation = PI / 2
		y_scale = 1
	elif Input.is_action_just_pressed("right_upgrade"):
		upgrade_vec = Vector2.RIGHT
		upgrade_rotation = 0
		y_scale = 1
	elif Input.is_action_just_pressed("left_upgrade"):
		upgrade_vec = Vector2.LEFT
		upgrade_rotation = PI
		y_scale = -1
	else:
		return
	var upgrade_scene = load("res://weapons/basic_weapon/revolver.tscn")
	var upgrade_node = upgrade_scene.instantiate()
	upgrade_node.position = upgrade_vec * 25
	upgrade_node.rotation = upgrade_rotation
	upgrade_node.scale.y = y_scale
	get_parent().add_child(upgrade_node)
	upgrade_count -= 1
	if upgrade_count == 0:
		hide()
