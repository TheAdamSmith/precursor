class_name LevelRoot
extends Node2D


func _ready():
	MultiplayerManager.player_loaded.rpc()
