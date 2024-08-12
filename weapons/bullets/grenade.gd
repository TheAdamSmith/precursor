class_name Grenade
extends Bullet

@export var aoe_damage = 70.0
@export var aoe_scale = 10

var explosion_active = false


func _ready():
	top_level = true
	$AreaOfEffect.body_entered.connect(_on_body_entered_aoe)
	$Vfx.hide()
	$AreaOfEffect.scale = Vector2(aoe_scale, aoe_scale)
	$Vfx.scale *= $AreaOfEffect.scale


func _on_body_entered(body):
	super._on_body_entered(body)
	explosion_active = true
	for body_in_aoe in $AreaOfEffect.get_overlapping_bodies():
		EventService.entity_damaged.emit(self, body_in_aoe, aoe_damage)


func _on_body_entered_aoe(body):
	if not explosion_active:
		return
	EventService.entity_damaged.emit(self, body, aoe_damage)


func _on_vfx_animation_looped():
	queue_free()
