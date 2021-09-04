extends Spatial

export var swing_amount_max : float = 20
export var swing_speed : float = 50

onready var player = $'../'

var init_rot : Vector3
var rot_off : Vector3

func _ready():
	init_rot = rotation_degrees

func _process(delta):
	# Add rotation offset
	rotation_degrees = init_rot + rot_off
	rot_off = rot_off.linear_interpolate(Vector3.ZERO, swing_speed * delta)
	if rot_off.length() > swing_amount_max:
		rot_off = rot_off.normalized() * swing_amount_max

func _input(event):
	# Looking around
	if event is InputEventMouseMotion:
		rot_off.y += event.relative.x * player.mouse_sensitivity_x
	
