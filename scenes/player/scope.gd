extends MeshInstance3D

const CAMERA_OFFSET := Vector3(0.52, 0, 0)
const ZOOM_SPEED:float = 0.5
const MIN_ZOOM:float = 1.0
const MAX_ZOOM:float = 32.0

#input action "zoom_in"/"zoom_out"
var zoom:float = 1.0:
	set(value):
		if zoom != value:
			zoom = clamp(value, MIN_ZOOM, MAX_ZOOM)
			zoom_label.text = String.num(zoom, 2)


@onready var camera:Camera3D = $TargetViewport/Camera
@onready var view_area:MeshInstance3D = $ViewArea
@onready var target_viewport:SubViewport = $TargetViewport
@onready var zoom_label:Label3D = $ZoomLabel

# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	var mat = StandardMaterial3D.new()
	mat.albedo_texture = target_viewport.get_texture()
	mat.disable_receive_shadows = true
	view_area.material_override = mat


func _process(delta: float) -> void:
	var local_transform := Transform3D(Basis().rotated(Vector3(0,1,0),deg_to_rad(-90)), CAMERA_OFFSET)
	camera.global_transform = global_transform * local_transform
	camera.fov = 70.0 / zoom
	


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		zoom += Input.get_axis("zoom_out","zoom_in") * ZOOM_SPEED
