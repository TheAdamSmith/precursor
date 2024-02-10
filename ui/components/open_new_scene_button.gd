class_name OpenNewSceneButton
extends Button

@export_file() var next_scene_path : String


func _ready():
	button_down.connect(_on_button_pressed)


func _on_button_pressed():
	EventService.change_scene.emit(next_scene_path)
