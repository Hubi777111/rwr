extends XROrigin3D

@export var move_speed: float = 2.5
@export var deadzone: float = 0.15
@onready var xr_camera: XRCamera3D = $XRCamera3D
@onready var left_ctrl: XRController3D = $LeftController

func _physics_process(delta: float) -> void:
	var dir := Vector3.ZERO

	# Wyznaczamy kierunek "przód" i "prawo" na podstawie tego, gdzie patrzy głowa
	var fwd := -xr_camera.global_transform.basis.z
	fwd.y = 0.0 # Opcja 5.2 z instrukcji: Wyzerowanie osi Y
	fwd = fwd.normalized()
	
	var right := xr_camera.global_transform.basis.x
	right.y = 0.0 # Opcja 5.2 z instrukcji: Wyzerowanie osi Y
	right = right.normalized()

	# Pobieramy wychylenie lewej gałki z kontrolera WebXR
	var v: Vector2 = left_ctrl.get_vector2("thumbstick")
	
	# Ignorujemy delikatne drgnięcia drążka (deadzone)
	if v.length() < deadzone:
		v = Vector2.ZERO

	# Łączymy kierunek patrzenia z wychyleniem gałki
	dir += fwd * (-v.y) + right * (v.x)

	# Jeśli gałka jest wychylona, przesuwamy gracza
	if dir.length() > 0.0:
		global_translate(dir.normalized() * move_speed * delta)
