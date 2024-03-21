extends Node2D

#TODO programatically find the boundary of the level
var xBoundary = 2000
var yBoundary = 2000

func _ready():
	while true :
		await get_tree().create_timer(1.0).timeout 
		spawn_enemy()

func spawn_enemy():
	var enemy = preload("res://enemies/enemy.tscn").instantiate()
	enemy.global_position = Vector2(randi_range(50,xBoundary),randi_range(50,yBoundary))
	add_child(enemy)
