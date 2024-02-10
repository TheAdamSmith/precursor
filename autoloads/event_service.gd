extends Node

signal change_scene(scene_path)
signal start_game
signal quit_game


func _ready():
    change_scene.connect(_change_scene)


func _change_scene(scene_path):
    var next_scene = load(scene_path)
    get_tree().change_scene_to_packed(next_scene)
