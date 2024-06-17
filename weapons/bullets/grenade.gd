class_name Grenade
extends RigidBody2D

@export var damage = 0.0
@export var aoe_damage = 70.0
@export var aoe_scale = 10

var disabled = false
var explosion_active = false


func _ready():
	top_level = true
	$AreaOfEffect.body_entered.connect(_on_body_entered_aoe)
	$Vfx.hide()
	$Vfx.scale = Vector2(aoe_scale, aoe_scale)
	$AreaOfEffect.scale = $Vfx.scale


func _on_body_entered(body):
	if disabled:
		return
	disabled = true
	linear_velocity.x = 0
	linear_velocity.y = 0
	$Vfx.show()
	$Vfx.play()
	EventService.entity_damaged.emit(self, body, damage)
	explosion_active = true
	for body_in_aoe in $AreaOfEffect.get_overlapping_bodies():
		EventService.entity_damaged.emit(self, body_in_aoe, aoe_damage)
	await get_tree().create_timer(0.05).timeout 
	$SmallBullet.hide()


func _on_body_entered_aoe(body):
	if not explosion_active:
		return
	EventService.entity_damaged.emit(self, body, aoe_damage)


func _on_vfx_animation_looped():
	queue_free()
