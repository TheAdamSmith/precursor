extends Node

signal change_scene(scene_path)
signal start_game
signal quit_game
signal change_pause_state

enum GAME_STATE {MENU, IN_PROGRESS}
var game_state


func _ready():
    process_mode = Node.PROCESS_MODE_ALWAYS
    game_state = GAME_STATE.MENU
    change_scene.connect(_change_scene)
    start_game.connect(_start_game)
    quit_game.connect(_quit_game)
    change_pause_state.connect(_change_pause_state)


func _input(event):
    if game_state == GAME_STATE.IN_PROGRESS and event.is_action_pressed("ui_cancel"):
        _change_pause_state()


func _change_scene(scene_path):
    if scene_path.begins_with("res://ui"):
        if game_state == GAME_STATE.IN_PROGRESS:
            game_state = GAME_STATE.MENU
        if get_tree().paused:
            _change_pause_state()
    var next_scene = load(scene_path)
    get_tree().change_scene_to_packed(next_scene)


func _start_game():
    game_state = GAME_STATE.IN_PROGRESS
    var next_scene = load("res://levels/planet_level/planet_level.tscn")
    get_tree().change_scene_to_packed(next_scene)


func _quit_game():
    get_tree().quit()


func _change_pause_state():
    get_tree().paused = not get_tree().paused
    PauseScreen.pause_state_changed(get_tree().paused)
