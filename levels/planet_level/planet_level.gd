class_name PlanetArena
extends TileMap

#TODO programatically find the boundary of the level
var xBoundary = 2000
var yBoundary = 2000
var arena_group : String


func _ready():
	print(self)
	while true :
		await get_tree().create_timer(1.0).timeout 
		spawn_enemy()


func spawn_enemy():
	var enemy = preload("res://enemies/enemy.tscn").instantiate()
	enemy.global_position = position + Vector2(randi_range(50,xBoundary),randi_range(50,yBoundary))
	if not arena_group:
		for group in get_groups():
			if group.contains("Arena"):
				arena_group = group
				break
	enemy.add_to_group(arena_group)
	add_child(enemy)
