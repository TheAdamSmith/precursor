class_name BgmSelector
extends Node

# add bgm_selector.tscn scene to scenes to play Background Music

# audio file to play
@export var bgm: AudioStream 
# set to true if you just want BGM to stop playing
# (also nice during dev if you don't want to hear the music)
@export var stop_bgm: bool = false 
# set to true if you want the BGM to restart from the beginning for the same audio file
@export var restart_bgm: bool = false 
@export_range(0.0, 1.0, 0.001) var bgm_volume_linear : float = 1.0

func _ready() -> void:
	if bgm and not stop_bgm:
		SoundManager.play_bgm(bgm, bgm_volume_linear, restart_bgm)
	elif stop_bgm:
		SoundManager.stop_bgm()
	else:
		printerr("No BGM set, or Stop Bgm is false, in Inspector for BgmSelector")
