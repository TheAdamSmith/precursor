extends Node2D
class_name EnemySpawner

@export var min_x : int
@export var max_x : int
@export var min_y : int
@export var max_y : int
@export var spawn_time = 1.0
var spawn_timer : SceneTreeTimer

var enemyModels = ["alien_v1", "alien_v2"]

func spawn_enemy():
	var position = Vector2(randi_range(min_x,max_x),randi_range(min_y,max_y))
	var enemyModel = enemyModels.pick_random()
	var enemySprite = load("res://enemies/enemyAnimatedSprite2D/" + enemyModel + ".tscn").instantiate()
	
	#set a generic name for the sprite frame object so that it can be referenced generically
	enemySprite.set_name("enemySprite")
	
	var enemy = load("res://enemies/enemy.tscn").instantiate()
	enemy.add_child(enemySprite)
	enemy.global_position = position
	enemy.add_to_group("enemy")
	enemy.add_to_group(ArenaUtilities.get_arena_name_by_position(enemy.global_position))
	add_child(enemy)


func _physics_process(delta):
	if not spawn_timer or spawn_timer.time_left == 0.0:
		spawn_enemy()
		spawn_timer = get_tree().create_timer(spawn_time)
