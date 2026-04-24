extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

const MOUSE_SENSITIVITY:float = 0.005
const MAX_PITCH_ANGLE:float = 85.0

@onready var cam_pivot:Node3D = $Pivot
@onready var cam:Camera3D = $Pivot/Camera3D


func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("movement_left", "movement_right", "movement_fore", "movement_back")
	var direction := Vector3(input_dir.x, Input.get_axis("movement_down","movement_up"), input_dir.y).normalized() * cam_pivot.quaternion
	if direction:
		velocity.x = direction.x * SPEED
		velocity.y = direction.y * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
