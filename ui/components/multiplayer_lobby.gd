class_name MultiplayerLobby
extends VBoxContainer

@onready var player_list = $PLayerListContainer
@export var num_players_per_side_selector : NumberSelector


func _ready():
	# Revealed when lobby is created or joined
	hide()
	MultiplayerManager.player_connected.connect(_on_player_connected)
	MultiplayerManager.player_disconnected.connect(_on_player_disconnected)
	MultiplayerManager.server_disconnected.connect(_on_server_disconnected)
	MultiplayerManager.client_disconnected.connect(_on_client_disconnected)
	_clear_player_list()


func _clear_player_list():
	for child in player_list.get_children():
		player_list.remove_child(child)


func _add_player_to_list(peer_id, name):
	var label = Label.new()
	label.text = name
	label.name = str(peer_id)
	player_list.add_child(label)


func _remove_player_from_list(peer_id):
	for child in player_list.get_children():
		if child.name == str(peer_id):
			player_list.remove_child(child)
			return


func _on_player_connected(peer_id, player_info):
	_add_player_to_list(peer_id, player_info["name"])
	_update_num_selector()


func _on_player_disconnected(peer_id):
	_remove_player_from_list(peer_id)


func _on_server_disconnected():
	hide()
	_clear_player_list()


func _on_client_disconnected():
	hide()
	_clear_player_list()


func _update_num_selector():
	if not num_players_per_side_selector:
		return
	num_players_per_side_selector.min = max(ceil(MultiplayerManager.players.size() / 2.0), 1)
	if num_players_per_side_selector.value < num_players_per_side_selector.min:
		num_players_per_side_selector.value = num_players_per_side_selector.min
	num_players_per_side_selector.values_updated.emit()
	
