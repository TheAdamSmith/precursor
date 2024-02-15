extends RigidBody2D

@export var fire_rate = 1.5
@export var bullet_speed = 1000

var bullet = preload("res://weapons/basic_weapon/bullet.tscn")
var can_fire = true
var screen_size
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if can_fire:
		var bullet_instance = bullet.instantiate()
		bullet_instance.position = $BulletPoint.get_global_position()
		bullet_instance.rotation = $Revolver.global_rotation
		bullet_instance.apply_impulse(Vector2(bullet_speed, 0).rotated($Revolver.global_rotation))
		get_tree().get_root().add_child(bullet_instance)
		can_fire = false
		await get_tree().create_timer(fire_rate).timeout
		can_fire = true
