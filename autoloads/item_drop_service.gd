extends Node

signal random_item_drop_event(item_level, item_tier, item_position, drop_chance)

var items = []


func _ready():
	items = DirUtilities.get_files_by_extension("res://items/", ".tscn", true)
	print(items)
	random_item_drop_event.connect(_on_random_item_drop_event)


func _on_random_item_drop_event(item_level, item_tier, item_position, drop_chance):
	if randf_range(0.0, 1.0) > drop_chance:
		return
	var item = load(items.pick_random()).instantiate()
	item.global_position = item_position
	item.z_index = -1
	get_tree().current_scene.add_child(item)
