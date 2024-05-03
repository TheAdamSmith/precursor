class_name Bullet
extends RigidBody2D

@export var damage = 0.0
var disabled = false

func _ready():
	$Vfx.hide()


func _on_body_entered(body):
	if disabled:
		return
	disabled = true
	linear_velocity.x = 0
	linear_velocity.y = 0
	$Vfx.show()
	$Vfx.play()
	EventService.entity_damaged.emit(self, body, damage)
	await get_tree().create_timer(0.05).timeout 
	$SmallBullet.hide()


func _on_vfx_animation_looped():
	queue_free()
