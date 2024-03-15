extends Node2D

var bgm_player: AudioStreamPlayer

func play_bgm(stream: AudioStream, volume_db: float = -10):
	if not bgm_player:
		bgm_player = AudioStreamPlayer.new()
		add_child(bgm_player)
	bgm_player.autoplay = true
	bgm_player.stream = stream
	bgm_player.volume_db = volume_db
	bgm_player.play()

func play_sfx(owner: Node2D, stream: AudioStream, volume_db: float = 0, max_distance: float = 700):
	var instance = AudioStreamPlayer2D.new()
	instance.stream = stream
	instance.finished.connect(remove_node.bind(instance))
	instance.volume_db = volume_db
	instance.max_distance = max_distance
	owner.add_child(instance)
	instance.play()
	
func remove_node(instance: AudioStreamPlayer2D):
	instance.queue_free()
