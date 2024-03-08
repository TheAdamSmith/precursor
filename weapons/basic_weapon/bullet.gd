extends RigidBody2D

func _ready():
	$Vfx.hide()
	
func _on_body_entered(body):
	linear_velocity.x = 0
	linear_velocity.y = 0
	$Vfx.show()
	$Vfx.play()
	await get_tree().create_timer(0.05).timeout 
	$SmallBullet.hide()


func _on_vfx_animation_looped():
	queue_free()
