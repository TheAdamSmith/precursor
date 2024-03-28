extends Node2D

#TODO programatically find the boundary of the level
var xBoundary = 2000
var yBoundary = 2000
var enemyModels = ["alien-v1", "alien-v2"]

func _ready():
	while true :
		await get_tree().create_timer(1.0).timeout 
		spawn_enemy()

func spawn_enemy():
	var enemyModel = enemyModels.pick_random()
	var moveFrame1 = load("res://models/enemy_models/" + enemyModel + "/" + enemyModel + "-move1.png")
	var moveFrame2 = load("res://models/enemy_models/" + enemyModel + "/" + enemyModel + "-move2.png")
	
	var enemy = load("res://enemies/enemy.tscn").instantiate()
	var spriteFrames = enemy.get_node("AnimatedSprite2D").get_sprite_frames()

	spriteFrames.set_frame("move", 0, moveFrame1, 1)
	spriteFrames.set_frame("move", 1, moveFrame2, 1)
	
	enemy.global_position = Vector2(randi_range(50,xBoundary),randi_range(50,yBoundary))
	add_child(enemy)
