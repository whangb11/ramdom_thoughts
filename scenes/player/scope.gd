extends MeshInstance3D

@onready var camera:Camera3D = $TargetViewport/Camera
@onready var view_area:MeshInstance3D = $ViewArea
@onready var viewport:SubViewport = $TargetViewport

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
