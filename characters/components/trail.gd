class_name Trail
extends Line2D

@export var max_length : int
@export var position_source : Node2D

var point_queue : Array
var _add_points = false


func _ready():
	top_level = true
	if not position_source:
		position_source = get_parent()


func start_adding_points():
	_add_points = true


func stop_adding_points():
	_add_points = false


func _physics_process(delta):
	if _add_points:
		var point_pos = position_source.global_position
		point_queue.push_front(point_pos)
	if not _add_points or point_queue.size() > max_length:
		point_queue.pop_back()
	clear_points()
	for point in point_queue:
		add_point(point)
