extends Node2D
class_name BossSpawner

var bossModels = ["roosterBoss"]
var bossSpawned = false
@export var mapCenterX = 400
@export var mapCenterY = 400
var arena_group : String

# Called when the node enters the scene tree for the first time.
#func _ready():
	#while true :
		#await get_tree().create_timer(1.0).timeout 
		#if not bossSpawned:
			#bossSpawned = true
			#spawn_boss()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#print("spawned?? ", bossSpawned)
	if not bossSpawned:
		#aawait get_tree().create_timer(5.0).timeout 
		bossSpawned = true
		print("spawning boss")
		spawn_boss()

func spawn_boss():
	var position = Vector2(mapCenterX,mapCenterY)
	var bossModel = bossModels.pick_random()
	
	# get sub folder in path
	var bossPath =  bossModel + "/" + bossModel
	var bossSpawn = load("res://bosses/rooster_boss/roosterBoss.tscn").instantiate()
	#bossSpawn.set_name("roosterBoss")
	#set a generic name for the sprite frame object so that it can be referenced generically
	#bossSprite.set_name("bossSprite")
	
	#todo change to boss.tscn
	#boss.add_child(bossSprite)
	bossSpawn.global_position = position
	#bossSpawn.add_to_group("enemy")
	add_child(bossSpawn)
