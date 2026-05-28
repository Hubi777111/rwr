extends XRController3D

@onready var ray: RayCast3D = $RayCast3D
@onready var marker: MeshInstance3D = $"../../Marker" # Ścieżka do Markera w Main
@onready var xr_origin: XROrigin3D = $".." # XROrigin3D jest rodzicem kontrolera

func _ready():
    # Podpinamy sygnał wciśnięcia spustu
    button_pressed.connect(_on_button_pressed)

func _process(_delta: float) -> void:
    # RayCast sprawdza kolizję
    if ray.is_colliding():
        marker.global_transform.origin = ray.get_collision_point()
        marker.visible = true
    else:
        marker.visible = false

func _on_button_pressed(button_name: String):
    # Teleportacja na "trigger_click"
    if button_name == "trigger_click" and ray.is_colliding():
        var target = ray.get_collision_point()
        
        # Logika teleportacji
        var origin_tf := xr_origin.global_transform
        # Pobieramy pozycję kamery, żeby po teleportacji gracz nie był "w ziemi"
        var cam_tf = xr_origin.get_node("XRCamera3D").global_transform
        var cam_offset = cam_tf.origin - origin_tf.origin
        
        cam_offset.y = 0.0 # Zerujemy wysokość, żeby trzymać się poziomu podłogi
        origin_tf.origin = Vector3(target.x - cam_offset.x, target.y, target.z - cam_offset.z)
        xr_origin.global_transform = origin_tf
