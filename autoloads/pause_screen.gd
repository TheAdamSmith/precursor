extends CanvasLayer

@onready var pause_menu = $PauseMenu

func _ready():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	hide()


func pause_state_changed(paused):
	if paused:
		show()
		pause_menu.initial_focus.grab_focus()
	else:
		hide()
