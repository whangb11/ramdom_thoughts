extends Camera3D


const MOUSE_SENSITIVITY:float = 0.005
const MAX_PITCH_ANGLE:float = 85.0

func _ready():
	pass
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_update_camera_rotation(event.relative)


func  _update_camera_rotation(mouse_relative: Vector2):
	var pivot_quat: Quaternion = get_parent().quaternion
	var yaw_quat := Quaternion(Vector3.UP, -mouse_relative.x * MOUSE_SENSITIVITY)
	pivot_quat = yaw_quat * pivot_quat
	var current_x_axis: Vector3 = pivot_quat * Vector3.RIGHT
	var pitch_quat := Quaternion(current_x_axis, -mouse_relative.y * MOUSE_SENSITIVITY)
	pivot_quat = pitch_quat * pivot_quat
	var euler: Vector3 = pivot_quat.get_euler()
	euler.x = clamp(euler.x, deg_to_rad(-MAX_PITCH_ANGLE), deg_to_rad(MAX_PITCH_ANGLE))
	get_parent().quaternion = Quaternion.from_euler(euler)


func _limit_pitch(original_quat: Quaternion) -> Quaternion:
	var euler: Vector3 = original_quat.get_euler()
	euler.x = clamp(euler.x, deg_to_rad(-90.0), deg_to_rad(90.0))
	return Quaternion.from_euler(euler)
