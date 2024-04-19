extends Node2D
class_name EnemySpawner

@export var xBoundary = 2000
@export var yBoundary = 2000
var arena_group : String

var enemyModels = ["alien_v1", "alien_v2"]

func _ready():
	while true :
		await get_tree().create_timer(1.0).timeout 
		spawn_enemy()

func spawn_enemy():
	var position = Vector2(randi_range(50,xBoundary),randi_range(50,yBoundary))
	var enemyModel = enemyModels.pick_random()
	var enemySprite = load("res://enemies/enemyAnimatedSprite2D/" + enemyModel + ".tscn").instantiate()
	
	#set a generic name for the sprite frame object so that it can be referenced generically
	enemySprite.set_name("enemySprite")
	
	var enemy = load("res://enemies/enemy.tscn").instantiate()
	enemy.add_child(enemySprite)
	enemy.global_position = position
	if not arena_group:
		for group in get_groups():
			if group.contains("Arena"):
				arena_group = group
				break
	enemy.add_to_group(arena_group)
	add_child(enemy)
