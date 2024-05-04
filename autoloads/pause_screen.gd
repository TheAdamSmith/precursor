extends CanvasLayer

@onready var pause_menu = $PauseMenu
@onready var pause_label = $PauseMenu/VBoxContainer/Label


func _ready():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	hide()


func pause_state_changed(paused, label):
	if paused:
		show()
		pause_label.text = label
		pause_menu.initial_focus.grab_focus()
	else:
		hide()
