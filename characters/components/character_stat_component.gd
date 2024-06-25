class_name CharacterStatComponent
extends StatComponent


@export var base_stats = {
	"speed": 200,
	"health": 100,
	"attacks_per_sec": 1.0,
	"damage": 10.0,
}


func _ready():
	_base_stats = base_stats
	super._ready()


func get_current_speed():
	return _get_modified_stat("speed")


func get_current_health():
	return _get_modified_stat("health")


func get_current_attacks_per_sec():
	return _get_modified_stat("attacks_per_sec")


func get_current_damage():
	return _get_modified_stat("damage")
