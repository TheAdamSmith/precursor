extends Node

# Game State Signals
signal change_scene(scene_path)
signal start_game(type : EventService.GAME_TYPE, game_info : Dictionary)
signal load_multiplayer_level
signal quit_game
signal change_pause_state

#  In-game Signals
signal entity_damaged(damaging_entity, damaged_entity, base_damage)
signal entity_death(damaging_entity, dying_entity)

enum GAME_STATE {MENU, IN_PROGRESS}
enum GAME_TYPE {SINGLE_PLAYER, MULTIPLAYER}
var game_state
var game_type
var main_arena_num


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	game_state = GAME_STATE.MENU
	game_type = null

	# Connect game state signals
	change_scene.connect(_change_scene)
	start_game.connect(_start_game)
	load_multiplayer_level.connect(_on_load_multiplayer_level)
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
		if game_state == GAME_STATE.IN_PROGRESS:
			game_state = GAME_STATE.MENU
			game_type = null
		if get_tree().paused:
			_change_pause_state()
	var next_scene = load(scene_path)
	get_tree().change_scene_to_packed(next_scene)


func _start_game(type, game_info):
	game_state = GAME_STATE.IN_PROGRESS
	game_type = type
	if game_type == GAME_TYPE.SINGLE_PLAYER:
		print("starting single")
		main_arena_num = 0
		var parent_node = ArenaUtilities.create_arenas_root_node(2, game_info["num_players"], main_arena_num, true, .5)
		var bgm_selector = load("res://audio/level_2_bgm.tscn").instantiate()
		parent_node.add_child(bgm_selector)
		bgm_selector.owner = parent_node
		var scene = PackedScene.new()
		scene.pack(parent_node)
		get_tree().change_scene_to_packed(scene)
	elif game_type == GAME_TYPE.MULTIPLAYER:
		get_tree().change_scene_to_packed(load("res://utilities/multiplayer/multiplayer_base_scene.tscn"))
	else:
		assert(false, "Unknown game typed passed into _start_game")


func _on_load_multiplayer_level():
	print($/root/MultiplayerBaseScene/LevelRoot)
	ArenaUtilities.create_muliplayer_root_node(MultiplayerManager.players.size(), 1, $/root/MultiplayerBaseScene/LevelRoot)


func _quit_game():
	get_tree().quit()


func _change_pause_state():
	get_tree().paused = not get_tree().paused
	PauseScreen.pause_state_changed(get_tree().paused, "Paused")


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
	if dying_character.is_in_group("player"):
		var player_camera = dying_character.find_child("PlayerCamera")
		if player_camera:
			player_camera.reparent(dying_character.get_parent())
			player_camera.global_position = dying_character.global_position
		if ArenaUtilities.get_count_in_arena_by_group(get_tree(), "player", dying_character.arena_group) <= 1:
			get_tree().paused = not get_tree().paused
			var game_over_label = "You Win!"
			if dying_character.arena_group == "arena%d" % main_arena_num:
				game_over_label = "You Lose!"
			PauseScreen.pause_state_changed(get_tree().paused, game_over_label)
	dying_character.queue_free()


func _get_character_body_2d_parent(child):
	var curr_node = child
	while curr_node:
		if curr_node is CharacterBody2D:
			return curr_node
		curr_node = curr_node.get_parent()
	return curr_node
