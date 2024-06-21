class_name WeaponStatScaler
extends Resource

# NOTE: These values are not meant to be changed, they represent reasonable starters vals
# If you want to change values for a specific character, update or create a new .tres file

@export var up_weapon = load("res://weapons/basic_weapon/assault_rifle.tscn")
@export var down_weapon = load("res://weapons/basic_weapon/shotgun.tscn")
@export var right_weapon = load("res://weapons/basic_weapon/sniper.tscn")
@export var left_weapon = load("res://weapons/basic_weapon/grenade_launcher.tscn")

@export var up_weapon_base_stats = {
	"fire_rate": .3,
	"bullet_speed": 800.0,
	"bullet_damage": 5.0,
	"piercing_num": 0,
}

@export var up_weapon_per_level_stat_adders = {
	"fire_rate": 3,
	"bullet_speed": 800.0,
	"bullet_damage": 5.0,
	"piercing_num": 0,
}

@export var down_weapon_base_stats = {
	"fire_rate": 0.5,
	"bullet_speed": 500.0,
	"bullet_damage": 5.0,
	"piercing_num": 0,
}

@export var right_weapon_base_stats = {
	"fire_rate": 0.25,
	"bullet_speed": 1000.0,
	"bullet_damage": 50.0,
	"piercing_num": 1,
}

@export var left_weapon_base_stats = {
	"fire_rate": 0.18,
	"bullet_speed": 500.0,
	"bullet_damage": 10.0,
	"aoe_damage": 40.0,
	"aoe_scale": 10.0,
	"piercing_num": 0,
}
