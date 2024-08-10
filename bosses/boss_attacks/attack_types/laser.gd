class_name Laser
extends RigidBody2D

@export var damagePerFrame = 0.15
@onready var player = get_node("/root/Level/playerv2")

func _physics_process(delta):
	self.look_at(player.global_position)
	var overlaps = get_node("LaserBox").get_overlapping_bodies()
	var overlaps_player = overlaps.has(player)
	if overlaps_player:
		SoundManager.play_sfx(self, load("res://assets/audio/sfx/hit.wav"))
		EventService.entity_damaged.emit(self, player, damagePerFrame)
	#print(overlaps_player)
