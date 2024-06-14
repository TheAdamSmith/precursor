class_name ArenaUtilities

const TILE_SIZE = 32  # In pixels
const ARENA_WIDTH = 64 * TILE_SIZE  # In pixels
const ARENA_HEIGHT = 64 * TILE_SIZE  # In pixels


static func get_arena_name_by_position(global_position : Vector2):
	return "arena%d" % floori(global_position.x / ARENA_WIDTH)


static func create_arenas_root_node(num_arenas, num_players_per_side, main_arena = 0, enemy_spawner = true, enemies_per_second_per_player = .5):
	var parent_node = Node2D.new()
	var player_spawned = false
	for i in num_arenas:
		var arena = load("res://levels/arenas/planet_arena.tscn").instantiate()
		# Spawns arenas in a line going right
		# Will want to reconsider if we ever use more than 2 arenas
		arena.position.x = i * ARENA_WIDTH
		arena.position.y = 0
		arena.z_index = -1
		parent_node.add_child(arena)
		arena.owner = parent_node
		if enemy_spawner:
			var spawner = EnemySpawner.new()
			# Following assumes 1 tile boundary
			spawner.min_x = i * ARENA_WIDTH + TILE_SIZE
			spawner.max_x = (i + 1) * ARENA_WIDTH - TILE_SIZE
			spawner.min_y = TILE_SIZE
			spawner.max_y = ARENA_HEIGHT - TILE_SIZE
			spawner.spawn_time = 1 / (enemies_per_second_per_player * num_players_per_side)
			parent_node.add_child(spawner)
			spawner.owner = parent_node
		for j in num_players_per_side:
			if not player_spawned and i == main_arena:
				var main_player = load("res://characters/player/playerv2.tscn").instantiate()
				parent_node.add_child(main_player)
				main_player.owner = parent_node
				main_player.position = arena.position + Vector2(ARENA_WIDTH / 2, ARENA_HEIGHT / 2)
				player_spawned = true
			else:
				var computer_player = load("res://characters/player/computer_player.tscn").instantiate()
				parent_node.add_child(computer_player)
				computer_player.owner = parent_node
				computer_player.position = arena.position + Vector2(ARENA_WIDTH / 2 + j * 2 * TILE_SIZE, ARENA_HEIGHT / 2) 
	return parent_node


static func create_muliplayer_root_node(num_players, num_arenas, parent_node):
	for i in num_arenas:
		var arena = load("res://levels/arenas/planet_arena.tscn").instantiate()
		arena.position.x = i * ARENA_WIDTH
		arena.position.y = 0
		arena.z_index = -1
		parent_node.add_child(arena)
		arena.owner = parent_node
		var peer_ids = MultiplayerManager.players.keys()
		var players = []
		var initial_positions = []
		for j in num_players:
			var main_player = load("res://characters/player/playerv2.tscn").instantiate()
			main_player.multiplayer_authority = peer_ids[j]
			var initial_pos = arena.position + Vector2(ARENA_WIDTH / 2 + j * TILE_SIZE, ARENA_HEIGHT / 2)
			main_player.position = initial_pos
			parent_node.add_child(main_player, true)
			main_player.set_initial_values.rpc(initial_pos, peer_ids[j])
			players.append(main_player)
			initial_positions.append(initial_pos)
		# Loop over again and set initial values afterplayers added as children
		# This is due to some weirdness with how MultiplayerSpawner handles replicating
		# initial values on peers
		for j in num_players:
			players[j].set_initial_values.rpc(initial_positions[j], peer_ids[j])


static func find_closest_in_arena_by_group(reference_node, group, arena_group):
	# big number idk if there is maxint in godot
	var closest_distance = 100000000
	var closest_in_group = null
	for node in reference_node.get_tree().get_nodes_in_group(arena_group):
		if not node.is_in_group(group):
			continue
		var enemy = node
		var distance = enemy.global_transform.origin.distance_to(reference_node.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_in_group = enemy
	return closest_in_group


static func get_count_in_arena_by_group(tree, group, arena_group):
	var node_count = 0
	for node in tree.get_nodes_in_group(arena_group):
		if node.is_in_group(group):
			node_count += 1
	return node_count


static func get_arena_center(arena_name : String):
	var arena_num = int(arena_name.replace("arena", ""))
	return Vector2(arena_num * ARENA_WIDTH + ARENA_WIDTH / 2, ARENA_HEIGHT / 2)
