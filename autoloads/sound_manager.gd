extends Node2D

var bgm_player: AudioStreamPlayer


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS


func play_bgm(stream: AudioStream, volume_db: float = -10, force_restart: bool = false):
	return
	if not bgm_player:
		bgm_player = AudioStreamPlayer.new()
		add_child(bgm_player)
	bgm_player.volume_db = volume_db
	if stream == bgm_player.stream and not force_restart:
		return
	bgm_player.autoplay = true
	bgm_player.stream = stream
	if force_restart:
		bgm_player.finished.connect(_loop_bgm)
	bgm_player.play()


func stop_bgm():
	if not bgm_player:
		print("Tried to stop BGM when no BGM player exists.")
		return
	bgm_player.stop()


func _loop_bgm():
	return
	bgm_player.play()


func play_sfx(owner: Node2D, stream: AudioStream, volume_db: float = 0, max_distance: float = 700):
	return
	var instance = AudioStreamPlayer2D.new()
	instance.stream = stream
	instance.finished.connect(remove_node.bind(instance))
	instance.volume_db = volume_db
	instance.max_distance = max_distance
	owner.add_child(instance)
	instance.play()


func remove_node(instance: AudioStreamPlayer2D):
	instance.queue_free()
