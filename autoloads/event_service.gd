extends Node

# Game State Signals
signal change_scene(scene_path)
signal start_game
signal quit_game
signal change_pause_state

#  In-game Signals
signal entity_damaged(damaging_entity, damaged_entity, base_damage)
signal entity_death(damaging_entity, dying_entity)

enum GAME_STATE {MENU, IN_PROGRESS}
var game_state

var level_bgm_mappings: Dictionary = {
	
}


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	game_state = GAME_STATE.MENU

	# Connect game state signals
	change_scene.connect(_change_scene)
	start_game.connect(_start_game)
	quit_game.connect(_quit_game)
	change_pause_state.connect(_change_pause_state)

	# Connect in-game signals
	entity_damaged.connect(_on_entity_damaged)
	entity_death.connect(_on_entity_death)


func _input(event):
	if game_state == GAME_STATE.IN_PROGRESS and event.is_action_pressed("ui_cancel"):
		_change_pause_state()


func _change_scene(scene_path):
	if scene_path.begins_with("res://ui"):
		if scene_path == "res://ui/main_menu.tscn":
			SoundManager.stop_bgm()
		if game_state == GAME_STATE.IN_PROGRESS:
			game_state = GAME_STATE.MENU
		if get_tree().paused:
			_change_pause_state()
	var next_scene = load(scene_path)
	get_tree().change_scene_to_packed(next_scene)


func _start_game():
	game_state = GAME_STATE.IN_PROGRESS
	SoundManager.play_bgm(load("res://assets/audio/bgm/planet_level_1.wav"))
	var next_scene = load("res://levels/planet_level/planet_level.tscn")
	get_tree().change_scene_to_packed(next_scene)


func _quit_game():
	get_tree().quit()


func _change_pause_state():
	get_tree().paused = not get_tree().paused
	PauseScreen.pause_state_changed(get_tree().paused)


func _on_entity_damaged(damaging_entity, damaged_entity, base_damage):
	var damaged_character = _get_character_body_2d_parent(damaged_entity)
	if damaged_character:
		var health_comps = damaged_character.find_children("", "HealthComponent")
		if health_comps:
			for health_comp in health_comps:
				health_comp.apply_damage(base_damage, damaging_entity)


func _on_entity_death(damaging_entity, dying_entity):
	var dying_character = _get_character_body_2d_parent(dying_entity)
	if dying_character.has_method("give_experience"):
		var damaging_character = _get_character_body_2d_parent(damaging_entity)
		if damaging_character:
			var exp_comps = damaging_character.find_children("", "ExperienceComponent")
			if exp_comps:
				for exp_comp in exp_comps:
					exp_comp.add_exp(dying_character.give_experience())
	dying_character.queue_free()


func _get_character_body_2d_parent(child):
	var curr_node = child
	while curr_node:
		if curr_node is CharacterBody2D:
			return curr_node
		curr_node = curr_node.get_parent()
	return curr_node
