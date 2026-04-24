extends GPUParticles3D


func attractor(pos: Vector3, h: float) -> Vector3:
	const sigma:float = 10.0
	const rho:float = 28.0
	const beta:float = 8.0 / 3.0
	# k1
	var k1 = Vector3(sigma * (pos.y - pos.x), pos.x * (rho - pos.z) - pos.y, pos.x * pos.y - beta * pos.z)
	# 中点
	var mid:Vector3 = pos + 0.5 * h * k1
	var k2:Vector3 = Vector3(sigma * (mid.y - mid.x), mid.x * (rho - mid.z) - mid.y, mid.x * mid.y - beta * mid.z)
	# 第二个中点
	mid = pos + 0.5 * h * k2
	var k3:Vector3 = Vector3(sigma * (mid.y - mid.x), mid.x * (rho - mid.z) - mid.y, mid.x * mid.y - beta * mid.z)
	# k4
	var end:Vector3 = pos + h * k3
	var k4:Vector3 = Vector3(sigma * (end.y - end.x), end.x * (rho - end.z) - end.y, end.x * end.y - beta * end.z)
	# 组合k1-k4
	return pos + (h / 6.0) * (k1 + 2*k2 + 2*k3 + k4)
