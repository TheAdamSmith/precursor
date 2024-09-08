class_name CharacterStatComponent
extends StatComponent

## Dict of stat_name -> base val.
## NOTE: Can be updated for one-off test scenes, but should be set 
##  by an upgrade component using its stat_scaler.base_stats
@export var base_stats = { # Do NOT update values in this script and expect stats to change in game
	"speed": 0,
	"health": 0,
	"attacks_per_sec": 0.0,
	"damage": 0.0,
	"mass": 0.0,
	"displaced_duration_sec": 0.0,
	"acceleration_after_displacement": 0.0,
	"experience_given": 0.0,
	"scale": 0.0,
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


func get_current_experience_given():
	return _get_modified_stat("experience_given")


func get_current_scale():
	return _get_modified_stat("scale")
