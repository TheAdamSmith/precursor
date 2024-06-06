extends Panel
class_name TimePanel

var time: float = 0.0
var hours: int = 0
var minutes: int = 0
var seconds: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	seconds = fmod(time, 60)
	minutes = fmod(time, 3600) / 60
	hours = fmod(time, 86400) / 3600

	$Seconds.text = "%02d" % seconds
	$Minutes.text = "%02d:" % minutes
	$Hours.text = "%02d:" % hours
	pass
