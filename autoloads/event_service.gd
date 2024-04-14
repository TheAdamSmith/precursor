extends Node

# Game State Signals
signal change_scene(scene_path)
signal start_game(type : EventService.GAME_TYPE, game_info : Dictionary)
signal quit_game
signal change_pause_state

#  In-game Signals
signal entity_damaged(damaging_entity, damaged_entity, base_damage)
signal entity_death(damaging_entity, dying_entity)

enum GAME_STATE {MENU, IN_PROGRESS}
enum GAME_TYPE {SINGLE_PLAYER, MULTIPLAYER}
var game_state
var game_type


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	game_state = GAME_STATE.MENU
	game_type = null

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
		var parent_node = Node2D.new()
		var player_arena = load("res://levels/arenas/planet_arena.tscn").instantiate() as PlanetArena
		player_arena.add_to_group("Arena0")
		player_arena.position.x = 0
		player_arena.position.y = 0
		parent_node.add_child(player_arena)
		player_arena.owner = parent_node
		var main_player = load("res://characters/playerv2.tscn").instantiate() as Player
		main_player.add_to_group("Arena0")
		parent_node.add_child(main_player)
		main_player.owner = parent_node
		main_player.position = player_arena.position + Vector2(64 * 32 / 2, 64 * 32 / 2)
		for i in game_info["num_players"]:
			var cpu_arena_scene = load("res://levels/arenas/planet_arena.tscn")
			var cpu_arena = cpu_arena_scene.instantiate()
			var arena_pos_vec
			# The logic below only works cleanly for up to 8 cpu arenas
			# TODO: Make an elegant solution elegant for any number of arenas
			if (i / 4) % 2 == 0:
				arena_pos_vec = Vector2((i / 4 + 1) * 64 * 32, 0)
			else:
				arena_pos_vec = Vector2((i / 8 + 1) * 64 * 32, (i / 8 + 1) * 64 * 32)
			cpu_arena.position = Vector2i(arena_pos_vec.rotated((i * PI) / 2))
			cpu_arena.z_index = -1
			cpu_arena.add_to_group("Arena%d" % [i + 1])
			parent_node.add_child(cpu_arena)
			cpu_arena.owner = parent_node
			var computer_player = load("res://characters/computer_player.tscn").instantiate()
			parent_node.add_child(computer_player)
			computer_player.owner = parent_node
			computer_player.position = cpu_arena.position + Vector2(64 * 32 / 2, 64 * 32 / 2)
		var scene = PackedScene.new()
		scene.pack(parent_node)
		get_tree().change_scene_to_packed(scene)
	elif game_type == GAME_TYPE.MULTIPLAYER:
		var next_scene = load("res://levels/planet_level/planet_level.tscn")
		get_tree().change_scene_to_packed(next_scene)
	else:
		assert(false, "Unknown game typed passed into _start_game")


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
