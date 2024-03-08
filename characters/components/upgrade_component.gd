class_name UpgradeComponent
extends Node2D


@export var experience_component : ExperienceComponent


func _ready():
	experience_component.level_update.connect(_on_level_update)


func _on_level_update(level):
	pass
