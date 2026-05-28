extends XROrigin3D

@export var move_speed: float = 2.5
@export var deadzone: float = 0.15
@export var snap_angle: float = 15.0

@onready var xr_camera: XRCamera3D = $XRCamera3D
@onready var left_ctrl: XRController3D = $LeftController
@onready var right_ctrl: XRController3D = $RightController

var can_snap: bool = true

func _physics_process(delta: float) -> void:
	# --- LOKOMOCJA (LEWA GAŁKA) ---
	var dir := Vector3.ZERO
	var fwd := -xr_camera.global_transform.basis.z
	fwd.y = 0.0
	fwd = fwd.normalized()
	
	var right := xr_camera.global_transform.basis.x
	right.y = 0.0
	right = right.normalized()

	var v: Vector2 = left_ctrl.get_vector2("thumbstick")
	if v.length() < deadzone:
		v = Vector2.ZERO

	# POPRAWKA: Usunięto minus przed v.y
	dir += fwd * (v.y) + right * (v.x)

	if dir.length() > 0.0:
		global_translate(dir.normalized() * move_speed * delta)
		
	# --- OBRÓT SKOKOWY (PRAWA GAŁKA) ---
	var right_v: Vector2 = right_ctrl.get_vector2("thumbstick")
	
	if abs(right_v.x) > 0.5 and can_snap:
		var turn_dir = -sign(right_v.x) 
		rotate_y(deg_to_rad(snap_angle * turn_dir))
		can_snap = false
	elif abs(right_v.x) < 0.2:
		can_snap = true
