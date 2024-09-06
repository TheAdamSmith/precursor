class_name PlayerUpgradeComponent
extends UpgradeComponent

signal upgrade_input(upgrade_vec)

@export var experience_component : ExperienceComponent
@export var stat_component : StatComponent
@export var stat_scaler : StatScaler
@export var dash_component : DashComponent
@export var dash_scaler : DashStatScaler
@export var up_weapon : PackedScene
@export var up_weapon_stat_scaler : WeaponStatScaler
@export var down_weapon : PackedScene
@export var down_weapon_stat_scaler : WeaponStatScaler
@export var right_weapon : PackedScene
@export var right_weapon_stat_scaler : WeaponStatScaler
@export var left_weapon : PackedScene
@export var left_weapon_stat_scaler : WeaponStatScaler

var up_weapon_node : Gun
var up_weapon_level = 0
var down_weapon_node : Gun
var down_weapon_level = 0
var right_weapon_node : Gun
var right_weapon_level = 0
var left_weapon_node : Gun
var left_weapon_level = 0
var upgrade_count = 1


func _ready():
	experience_component.level_update.connect(_on_level_update)
	upgrade_input.connect(_handle_upgrade_input)
	show()


func _on_level_update(level):
	show()
	upgrade_count += 1
	_upgrade_stats(stat_component, stat_scaler, level)
	if dash_component:
		_upgrade_stats(dash_component.stat_component, dash_scaler, level)


func _handle_upgrade_input(upgrade_vec):
	if upgrade_count == 0:
		return
	var upgrade_scene
	var weapon_stat_scaler
	var weapon_level
	var upgrade_base_stats
	var upgrade_node
	var upgrade_rotation
	var y_scale
	if upgrade_vec == Vector2i.UP:
		weapon_stat_scaler = up_weapon_stat_scaler
		up_weapon_level += 1
		weapon_level = up_weapon_level
		if not up_weapon_node:
			upgrade_scene = up_weapon
			upgrade_base_stats = weapon_stat_scaler.base_stats
			upgrade_rotation = -PI / 2
			y_scale = 1
			up_weapon_node = _spawn_weapon(upgrade_scene, upgrade_base_stats, upgrade_vec, upgrade_rotation, y_scale)
		upgrade_node = up_weapon_node
	elif upgrade_vec == Vector2i.DOWN:
		weapon_stat_scaler = down_weapon_stat_scaler
		down_weapon_level += 1
		weapon_level = down_weapon_level
		if not down_weapon_node:
			upgrade_scene = down_weapon
			upgrade_base_stats = weapon_stat_scaler.base_stats
			upgrade_rotation = PI / 2
			y_scale = 1
			down_weapon_node = _spawn_weapon(upgrade_scene, upgrade_base_stats, upgrade_vec, upgrade_rotation, y_scale)
		upgrade_node = down_weapon_node
	elif upgrade_vec == Vector2i.RIGHT:
		weapon_stat_scaler = right_weapon_stat_scaler
		right_weapon_level += 1
		weapon_level = right_weapon_level
		if not right_weapon_node:
			upgrade_scene = right_weapon
			upgrade_base_stats = weapon_stat_scaler.base_stats
			upgrade_rotation = 0
			y_scale = 1
			right_weapon_node = _spawn_weapon(upgrade_scene, upgrade_base_stats, upgrade_vec, upgrade_rotation, y_scale)
		upgrade_node = right_weapon_node
	elif upgrade_vec == Vector2i.LEFT:
		weapon_stat_scaler = left_weapon_stat_scaler
		left_weapon_level += 1
		weapon_level = left_weapon_level
		if not left_weapon_node:
			upgrade_scene = left_weapon
			upgrade_base_stats = weapon_stat_scaler.base_stats
			upgrade_rotation = PI
			y_scale = -1
			left_weapon_node = _spawn_weapon(upgrade_scene, upgrade_base_stats, upgrade_vec, upgrade_rotation, y_scale)
		upgrade_node = left_weapon_node
	else:
		return
	if weapon_level > 1:
		_upgrade_stats(upgrade_node.stat_component, weapon_stat_scaler, weapon_level)

	upgrade_count -= 1
	if upgrade_count == 0:
		hide()


func _spawn_weapon(upgrade_scene, upgrade_base_stats, upgrade_vec, upgrade_rotation, y_scale):
	var upgrade_node = upgrade_scene.instantiate()
	upgrade_node.position = upgrade_vec * 35
	upgrade_node.rotation = upgrade_rotation
	upgrade_node.scale.y = y_scale
	get_parent().add_child(upgrade_node)
	upgrade_node.stat_component.set_base_stats(upgrade_base_stats)
	return upgrade_node
