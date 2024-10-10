extends Node

signal item_drop_event(item_level, item_tier, item_position, drop_chance)


func _ready():
	item_drop_event.connect(_on_item_drop_event)


func _on_item_drop_event(item_level, item_tier, item_position, drop_chance):
	if randf_range(0.0, 1.0) > drop_chance:
		return
	var item = load("res://items/healing_item.tscn").instantiate()
	item.global_position = item_position
	add_child(item)
