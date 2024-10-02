class_name DelayedEnemySpawnPoint
extends Node2D

@export var spawn_delay_seconds : float
@export var enemy_to_spawn : Node2D
@export var enemy_level : int


func _ready():
	var spawn_timer = get_tree().create_timer(spawn_delay_seconds, false, true)
	spawn_timer.timeout.connect(_on_spawn_delay_timeout)
	$AnimatedSprite2D.play("spawning")
	$AnimationPlayer.play("portal_spawn")
	$AnimationPlayer.speed_scale *= 1.0 / spawn_delay_seconds
	$AnimationPlayer.animation_finished.connect(_on_animation_finished)
	z_index = -1


func _on_spawn_delay_timeout():
	get_parent().add_child(enemy_to_spawn)
	var arena_group = ArenaUtilities.get_arena_name_by_position(enemy_to_spawn.global_position)
	enemy_to_spawn.add_to_group(arena_group)
	EnemySpawner._set_enemy_stats(enemy_to_spawn, enemy_level)


func _on_animation_finished():
	queue_free()
