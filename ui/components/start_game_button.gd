class_name StartGameButton
extends Button


func _ready():
    button_down.connect(_on_button_pressed)


func _on_button_pressed():
    get_tree().quit()

