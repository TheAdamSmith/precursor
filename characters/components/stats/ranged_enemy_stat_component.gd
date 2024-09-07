class_name RangedEnemyStatComponent
extends CharacterStatComponent

@export var ranged_base_stats : WeaponStatComponent


func _ready():
	_base_stats = base_stats
	super._ready()
