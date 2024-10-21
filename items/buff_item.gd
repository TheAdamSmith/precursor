class_name BuffItem
extends Item

@export var buff_duration_sec = 0.0
@export var invulnerable = false
@export var player_stat_adder_buffs : Dictionary
@export var player_stat_multiplier_buffs : Dictionary
@export var weapon_stat_adder_buffs : Dictionary
@export var weapon_stat_multiplier_buffs : Dictionary
 

func use(using_entity : Node2D):
	if not using_entity or not using_entity.has_node("UpgradeComponent"):
		return
	var upgrade_component : PlayerUpgradeComponent = using_entity.get_node("UpgradeComponent")
	upgrade_component.apply_player_buff(player_stat_adder_buffs, player_stat_multiplier_buffs, buff_duration_sec)
	upgrade_component.apply_weapon_buff(weapon_stat_adder_buffs, weapon_stat_multiplier_buffs, buff_duration_sec)
	if invulnerable and using_entity.has_node("HealthComponent"):
		var health_component = using_entity.get_node("HealthComponent")
		health_component.set_invulnerable(buff_duration_sec)
