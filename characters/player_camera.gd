class_name PlayerCamera
extends Camera2D

# zoom vars
@export var zoom_max: Vector2 = Vector2(.7, .7)
@export var zoom_min: Vector2 = Vector2(3, 3)
@export var zoom_lerp_speed: float = 4.0
@export var zoom_speed: float = .5
@export var zoom_total_time: float = 1

var starting_zoom: Vector2 = Vector2(zoom.x, zoom.y)
var zoom_out: bool = false
var zoom_in: bool = false

var zoom_triggered: bool = false

var time_lerping: float = 0.0
var target_zoom: Vector2

# pan vars
@export var pan_lerp_speed: float = 4
@export var pan_grab_frames: int = 4
@export var pan_velocity_dampening_factor: float = 5
@export var pan_velocity_div_factor: float = 150

var pan_grab_pos: Vector2
var panning: bool
var pan_velocity: Vector2
var pos_holder: Array = []
var camera_pan_vec: Vector2 
var camera_pan_vec_div_factor: float = 3 


func _unhandled_input(event: InputEvent):
	# zoom controls:
	# zoom_out -> mouse wheel down
	# zoom_trigger -> L2 + zoom_out_trigger -> right stick down
	if ((Input.is_action_just_released("zoom_out") or 
		  (Input.is_action_pressed("zoom_trigger") and Input.is_action_pressed("zoom_out_trigger")))
		  and zoom > zoom_max):
		zoom_out = true
		zoom_in = false
		target_zoom = zoom - Vector2(zoom_speed, zoom_speed)
		time_lerping = 0

	# zoom_in -> mouse wheel up
	# zoom_trigger -> L2 + zoom_in_trigger -> right stick up
	if ((Input.is_action_just_released("zoom_in") or 
		  (Input.is_action_pressed("zoom_trigger") and Input.is_action_pressed("zoom_in_trigger"))) 
		  and zoom < zoom_min):
		zoom_in = true
		zoom_out = false
		target_zoom = zoom + Vector2(zoom_speed, zoom_speed)
		time_lerping = 0

	# pan controls:
	# camera_pan_grab -> mouse wheel click
	if Input.is_action_just_pressed("camera_pan_grab"):
		panning = true
		pan_grab_pos = event.position
		pan_velocity = Vector2.ZERO
		pos_holder.clear()
	elif Input.is_action_just_released("camera_pan_grab"):
		if panning and pan_velocity != Vector2.ZERO:
			pan_velocity = pan_velocity.normalized() * (pan_velocity.length() / pan_velocity_div_factor)
		panning = false
	
	# prevent zoom and pan from happening at the same time on controller
	if !Input.is_action_pressed("zoom_trigger"):
		camera_pan_vec = Input.get_vector("camera_pan_left", "camera_pan_right",
										  "camera_pan_up", "camera_pan_down")
	else:
		camera_pan_vec = Vector2.ZERO

	if Input.is_action_just_pressed("center_player"):
		offset = Vector2.ZERO
		pan_velocity = Vector2.ZERO
		zoom = starting_zoom
		zoom_in = false
		zoom_out = false


func _physics_process(delta: float):
	if panning:
		var curr_mouse_pos = get_viewport().get_mouse_position()

		# keep track of mouse pos for $pan_grab_frames to generate a velocity
		# vector for the camera once "camera_pan_grab" is released
		# done in _physics_process so that FPS doesn't impact the pan velocity
		pos_holder.push_back(curr_mouse_pos)
		if len(pos_holder) == pan_grab_frames + 1:
			pos_holder.pop_front()
		pan_velocity = pos_holder[0] - pos_holder[len(pos_holder) - 1]


func _process(delta):
	# zoom logic
	if zoom_out == true and zoom >= zoom_max:
		time_lerping += delta
		zoom = zoom.slerp(target_zoom, zoom_lerp_speed * delta)
		if time_lerping >= zoom_total_time:
			zoom_out = false

	if zoom_in == true and zoom <= zoom_min:
		time_lerping += delta
		zoom = zoom.slerp(target_zoom, zoom_lerp_speed * delta)
		if time_lerping >= zoom_total_time:
			zoom_out = false

	# pan logic
	if panning:
		var curr_mouse_pos = get_viewport().get_mouse_position()
		offset += pan_grab_pos - curr_mouse_pos
		pan_grab_pos = curr_mouse_pos

	if not panning:
		offset += pan_velocity
		pan_velocity = pan_velocity.slerp(Vector2.ZERO, pan_velocity_dampening_factor * delta)

	if camera_pan_vec != Vector2.ZERO:
		offset += camera_pan_vec.normalized() * (camera_pan_vec.length() / camera_pan_vec_div_factor)
