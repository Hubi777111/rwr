extends XRController3D

@onready var raycast = $RayCast3D
@onready var marker = $"../../Marker"
@onready var xr_origin = $".."

func _ready():
	# Podłączamy sygnał wciśnięcia przycisku z kontrolera VR
	button_pressed.connect(_on_button_pressed)

func _process(delta):
	# Jeśli laser trafia w podłogę (nasz StaticBody3D)
	if raycast.is_colliding():
		marker.visible = true
		# Przesuwamy kuleczkę dokładnie w punkt trafienia lasera
		marker.global_position = raycast.get_collision_point()
	else:
		# Jeśli celujemy w niebo, ukrywamy kuleczkę
		marker.visible = false

func _on_button_pressed(button_name: String):
	# "trigger_click" to domyślna nazwa spustu w WebXR
	if button_name == "trigger_click" and raycast.is_colliding():
		var hit_point = raycast.get_collision_point()
		# Teleportujemy gracza (tylko w osiach X i Z, żeby nie wbić się pod ziemię!)
		xr_origin.global_position.x = hit_point.x
		xr_origin.global_position.z = hit_point.z
