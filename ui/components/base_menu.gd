class_name BaseMenu
extends Control

@export var initial_focus : Button


func _ready():
	initial_focus.grab_focus()
