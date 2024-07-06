class_name Bullet
extends Area2D

@export var damage = 0.0
@export var piercing_num = 0

var velocity = Vector2.ZERO
var disabled = false
var collision_count = 0


func _ready():
	top_level = true
	$Vfx.hide()


func apply_impulse(impulse_vector):
	velocity += impulse_vector


func _physics_process(delta):
	position += velocity * delta


func _on_body_entered(body):
	if disabled:
		return
	EventService.entity_damaged.emit(self, body, damage)
	collision_count += 1
	if body is Enemy and collision_count <= piercing_num:
		return
	disabled = true
	velocity.x = 0
	velocity.y = 0
	$Vfx.show()
	$Vfx.play()
	await get_tree().create_timer(0.05).timeout 
	$SmallBullet.hide()


func _on_vfx_animation_looped():
	queue_free()
