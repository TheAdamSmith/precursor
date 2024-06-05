class_name StartGameButton
extends Button

@export var game_type : EventService.GAME_TYPE
@export var num_players_selector : NumberSelector


func _ready():
	button_down.connect(_on_button_pressed)


func _on_button_pressed():
	var game_info = {}
	if num_players_selector:
		game_info["num_players"] = num_players_selector.value
	if game_type == EventService.GAME_TYPE.MULTIPLAYER:
		MultiplayerManager.start_game_for_peers.rpc(game_type, game_info)
	EventService.start_game.emit(game_type, game_info)
