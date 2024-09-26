class_name Trail
extends Line2D

@export var max_length : int
@export var position_source : Node2D
@export var point_fade_time_sec : float

var _base_width
var point_queue : Array
var _add_points = false
var _elapsed_time_since_last_fade = 0.0


func _ready():
	_base_width = width
	top_level = true
	if not position_source:
		position_source = get_parent()


func start_adding_points():
	width = _base_width * position_source.scale.x
	_add_points = true


func stop_adding_points():
	_add_points = false


func _physics_process(delta):
	_elapsed_time_since_last_fade += delta
	if _add_points:
		var point_pos = position_source.global_position
		point_queue.push_front(point_pos)
	if point_queue.size() > max_length or (not _add_points and _elapsed_time_since_last_fade >= point_fade_time_sec):
		point_queue.pop_back()
		_elapsed_time_since_last_fade -= point_fade_time_sec
	clear_points()
	for point in point_queue:
		if not _add_points:
			point += position_source.global_position - point_queue[0]
		add_point(point)
