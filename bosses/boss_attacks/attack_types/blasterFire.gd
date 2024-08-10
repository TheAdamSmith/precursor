class_name BlasterFire
extends RigidBody2D

@export var damage = 5.0
@onready var player = get_node("/root/Level/playerv2")
var blasterFireSpeed = 400

func _ready():
	var angle = global_position.direction_to(player.global_position).angle()
	apply_impulse(Vector2(blasterFireSpeed, 0).rotated(angle))
	SoundManager.play_sfx(self, load("res://assets/audio/sfx/hit.wav"))

func _on_body_entered(body):
	print("boddyy", body)
	#EventService.entity_damaged.emit(self, body, damage)
	#await get_tree().create_timer(0.05).timeout 

func _physics_process(delta): 
	var overlaps = get_node("Area2D").get_overlapping_bodies()
	var overlaps_player = overlaps.has(player)
	if overlaps_player:
		EventService.entity_damaged.emit(self, player, damage)
		queue_free()
	elif overlaps.size() > 0 and not overlaps.has(self.get_parent()):
		queue_free()
