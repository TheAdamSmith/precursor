extends CharacterBody2D
class_name RoosterBoss

var speed = 150.0
var attackAnimation = ["laser", ""]
var direction

@onready var player = get_node("/root/Level/playerv2")
@onready var animation = get_node("AnimatedSprite2D")
@onready var spawned = false

var laser = preload("res://bosses/boss_attacks/attack_types/laser.tscn")
var blasterFire = preload("res://bosses/boss_attacks/attack_types/blasterFire.tscn")
var attacking = false
var idle = false
var chargeAttacking = false
var concludedFrames = 0


#var direction = global_position.direction_to(player.global_position)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
		
	if not spawned: 
		animation.play("spawn")
		await animation.animation_finished
		spawned = true
		attacking = true
		#idle = false
	else:
		_shouldAction()
		if (not chargeAttacking):
			direction = global_position.direction_to(player.global_position)
		if attacking :
			_randomAttack()
			attacking = false
		elif not attacking:
			if not chargeAttacking:
				animation.play("idle")
			if direction.x > 0:
				animation.set_flip_h(true)
			else:
				animation.set_flip_h(false)
			
			velocity = direction * speed
			move_and_collide(velocity * delta)
			await get_tree().create_timer(5).timeout
				#print("idle for 5")
		 
		
func _shouldAction():
	if (concludedFrames / 60) == 10:
		concludedFrames = 0
		attacking = true
		print("action taken!!!")
		return true
	else:
		concludedFrames+=1 
		return false
		
		
func _laserAttack():
	#animation.play("laser")
	var laser_instance = laser.instantiate()
	laser_instance.set_position(Vector2(-20,0))
	speed = speed / 10 
	self.add_child(laser_instance)
	animation.play("laser")
	await get_tree().create_timer(5).timeout
	#await animation.animation_finished
	speed = speed * 10
	laser_instance.queue_free()

func _blasterFire():
	for x in 15:
		var blaster_instance = blasterFire.instantiate()
		#blaster_instance.set_position(Vector2(80,0))
		self.add_child(blaster_instance)
		await get_tree().create_timer(0.1).timeout
		
func _chargeAttack():
	chargeAttacking = true
	speed = 0
	#set direction of travel when spinning
	await get_tree().create_timer(1.5).timeout
	direction = global_position.direction_to(player.global_position)
	await get_tree().create_timer(0.3).timeout
	
	#exectire spin attack
	speed = 1000
	look_at(player.global_position)
	animation.play("spinAttack")
	await get_tree().create_timer(1).timeout
	
	#finish attack
	animation.play("idle")
	speed = 150

	chargeAttacking = false
	
	
		
func _randomAttack(): 
	var random = randi_range(0,2)
	random = 2
	match random:
		0: _laserAttack()
		1: _blasterFire()
		2: _chargeAttack()
		
