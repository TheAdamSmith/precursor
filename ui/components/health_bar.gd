class_name HealthBar
extends TextureProgressBar

@export var health_component : HealthComponent
@export var high_health_bar : Texture2D
@export var mid_health_bar : Texture2D
@export var low_health_bar : Texture2D
@export var max_mid_health_ratio = .5
@export var max_low_health_ratio = .25


func _ready():
	if not health_component.is_node_ready():
		print("awaiting health")
		await health_component.ready
	scale = Vector2(2, 2)
	health_component.health_update.connect(_on_health_update)


func _on_health_update(current_health, base_health, _health_diff):
	$Label.text = "%d/%d" % [current_health, base_health]
	var health_ratio = current_health / base_health
	if health_ratio > max_mid_health_ratio:
		texture_progress = high_health_bar
	elif health_ratio > max_low_health_ratio:
		texture_progress = mid_health_bar
	else:
		texture_progress = low_health_bar
	value = max_value * health_ratio
