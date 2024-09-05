class_name CharacterStatComponent
extends StatComponent


@export var base_stats = {
	"speed": 200,
	"health": 100,
	"attacks_per_sec": 1.0,
	"damage": 10.0,
	"mass": 1.0,
	"displaced_duration_sec": 0.15,
	"acceleration_after_displacement": 100.0,
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


func get_current_mass():
	return _get_modified_stat("mass")


func get_current_displaced_duration_sec():
	return _get_modified_stat("displaced_duration_sec")


func get_current_acceleration_after_displacement():
	return _get_modified_stat("acceleration_after_displacement")
