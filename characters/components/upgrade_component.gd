class_name UpgradeComponent
extends Node2D


signal upgrade_input(upgrade_vec)

@export var experience_component : ExperienceComponent
@export var stat_component : StatComponent
@export var stat_scaler : StatScaler
@export var up_weapon : PackedScene
@export var down_weapon : PackedScene
@export var right_weapon : PackedScene
@export var left_weapon : PackedScene
var up_weapon_node : Gun
var down_weapon_node
var right_weapon_node
var left_weapon_node
var upgrade_count = 1


func _ready():
	experience_component.level_update.connect(_on_level_update)
	upgrade_input.connect(_handle_upgrade_input)
	show()


func _on_level_update(level):
	show()
	upgrade_count += 1
	_upgrade_stats(level)


func _handle_upgrade_input(upgrade_vec):
	if upgrade_count == 0:
		return

	var upgrade_scene
	var upgrade_node
	var upgrade_rotation
	var y_scale
	if upgrade_vec == Vector2i.UP:
		if not up_weapon_node:
			upgrade_scene = up_weapon
			upgrade_rotation = -PI / 2
			y_scale = 1
			up_weapon_node = _spawn_weapon(upgrade_scene, upgrade_vec, upgrade_rotation, y_scale)
		upgrade_node = up_weapon_node
	elif upgrade_vec == Vector2i.DOWN:
		if not down_weapon_node:
			upgrade_scene = down_weapon
			upgrade_rotation = PI / 2
			y_scale = 1
			down_weapon_node = _spawn_weapon(upgrade_scene, upgrade_vec, upgrade_rotation, y_scale)
		upgrade_node = down_weapon_node
	elif upgrade_vec == Vector2i.RIGHT:
		if not right_weapon_node:
			upgrade_scene = right_weapon
			upgrade_rotation = 0
			y_scale = 1
			right_weapon_node = _spawn_weapon(upgrade_scene, upgrade_vec, upgrade_rotation, y_scale)
		upgrade_node = right_weapon_node
	elif upgrade_vec == Vector2i.LEFT:
		if not left_weapon_node:
			upgrade_scene = left_weapon
			upgrade_rotation = PI
			y_scale = -1
			left_weapon_node = _spawn_weapon(upgrade_scene, upgrade_vec, upgrade_rotation, y_scale)
		upgrade_node = left_weapon_node
	else:
		return
	# Level up weapon
	upgrade_count -= 1
	if upgrade_count == 0:
		hide()


func _spawn_weapon(upgrade_scene, upgrade_vec, upgrade_rotation, y_scale):
	var upgrade_node = upgrade_scene.instantiate()
	upgrade_node.position = upgrade_vec * 35
	upgrade_node.rotation = upgrade_rotation
	upgrade_node.scale.y = y_scale
	get_parent().add_child(upgrade_node)
	return upgrade_node


func _upgrade_stats(level):
	if not stat_scaler:
		return
	for stat_name in stat_scaler.per_level_stat_adders.keys():
		var stat_val = stat_scaler.per_level_stat_adders[stat_name]
		stat_component._register_stat_adder(stat_name, stat_val)

	for stat_name in stat_scaler.per_level_stat_multipliers.keys():
		var stat_val = stat_scaler.per_level_stat_multipliers[stat_name]
		stat_component._register_stat_mutliplier(stat_name, stat_val)

	if level in stat_scaler.level_specific_adders:
		for stat_name in stat_scaler.level_specific_adders[level].keys():
			var stat_val = stat_scaler.level_specific_adders[level][stat_name]
			stat_component._register_stat_adder(stat_name, stat_val)

	if level in stat_scaler.level_specific_multipliers:
		for stat_name in stat_scaler.level_specific_multipliers[level].keys():
			var stat_val = stat_scaler.level_specific_multipliers[level][stat_name]
			stat_component._register_stat_mutliplier(stat_name, stat_val)
