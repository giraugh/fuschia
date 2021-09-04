extends KinematicBody

# Movement Control
export var speed : float = 20
export var acceleration : float = 15
export var air_acceleration : float = 5
export var gravity : float = .98
export var max_term_vel : float = 54
export var jump_power : float = 20

# Camera control
export(float, .1, 1) var mouse_sensitivity_x : float = .3
export(float, .1, 1) var mouse_sensitivity_y : float = .3
export(float, -90, 0) var min_pitch : float = -90
export(float, 0, 90) var max_pitch : float = 90

# Physics
var vel : Vector3
var y_vel : float

onready var camera_pivot = $CameraPivot
onready var camera = $CameraPivot/CameraBoom/Camera

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_action_just_pressed("ui_uncancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	# Looking around
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sensitivity_x
		camera_pivot.rotation_degrees.x -= event.relative.y * mouse_sensitivity_y
		camera_pivot.rotation_degrees.x = clamp(camera_pivot.rotation_degrees.x, min_pitch, max_pitch)

func _physics_process(delta):
	handle_movement(delta)
	
func handle_movement(delta):
	# Acceleration
	var dir = determine_current_movement()
	var accel = acceleration if is_on_floor() else air_acceleration
	var des = vel.linear_interpolate(dir * speed, accel * delta)
	vel.x = des.x
	vel.z = des.z
	
	# Gravity
	vel.y = clamp(vel.y - gravity, -max_term_vel, max_term_vel)
	
	# Jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		vel.y = jump_power
	
	# Apply movement
	vel = move_and_slide(vel, Vector3.UP)

func determine_current_movement():
	var dir = Vector3()
	if Input.is_action_pressed("move_forward"):
		dir -= transform.basis.z
	if Input.is_action_pressed("move_backward"):
		dir += transform.basis.z
	if Input.is_action_pressed("move_left"):
		dir -= transform.basis.x
	if Input.is_action_pressed("move_right"):
		dir += transform.basis.x
	return dir.normalized()
