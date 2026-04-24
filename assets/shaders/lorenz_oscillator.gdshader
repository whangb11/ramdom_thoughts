shader_type particles;

uniform float h = 0.005;
uniform sampler2D noise;

const float sigma = 10.0f;
const float rho = 28.0f;
const float beta = 8.0 / 3.0;

// 洛伦兹导数
vec3 lorenz(vec3 p) {
	return vec3(
		sigma * (p.y - p.x),
		p.x * (rho - p.z) - p.y,
		p.x * p.y - beta * p.z
	);
}

// 4阶龙格‑库塔积分
vec3 rk4(vec3 pos, float pstep) {
	vec3 k1 = lorenz(pos);
	vec3 mid = pos + 0.5 * pstep * k1;
	vec3 k2 = lorenz(mid);
	mid = pos + 0.5 * pstep * k2;
	vec3 k3 = lorenz(mid);
	vec3 end_p = pos + pstep * k3;
	vec3 k4 = lorenz(end_p);
	return pos + (pstep / 6.0) * (k1 + 2.0*k2 + 2.0*k3 + k4);
}

float rand_from_id(uint id) {
	return fract(sin(float(id) * 12.9898) * 43758.5453);
}

void start() {
	vec3 init_pos = vec3(
		3.0 + (rand_from_id(RANDOM_SEED) - 0.5) * 2.0,
		5.0 + (rand_from_id(RANDOM_SEED + 1u) - 0.5) * 2.0,
		20.2 + (rand_from_id(RANDOM_SEED + 2u) - 0.5) * 2.0
	);
	CUSTOM.x = init_pos.x;
	CUSTOM.y = init_pos.y;
	CUSTOM.z = init_pos.z;
	CUSTOM.w = 0.0f;
	COLOR = vec4(1.0, 0.5, 0.2, 1.0);
}

void process() {
	vec3 pos = CUSTOM.xyz;
	float accum = CUSTOM.w;

	// 累积本帧经过的时间
	accum += DELTA;

	// 计算需要执行的子步数（最多 100 步，防止单帧过长）
	const int MAX_STEPS = 100;
	int steps = int(accum / h);
	steps = min(steps,MAX_STEPS);

	float used_time = float(steps) * h;
	accum -= used_time;   // 保留未用完的剩余时间

	// 循环执行子步
	for (int i = 0; i < MAX_STEPS; i++) {
		if (i < steps) {
			pos = rk4(pos, h);
		}
	}

	// 写回新状态
	CUSTOM = vec4(pos, accum);

	// 将粒子放置在计算出的世界坐标
	TRANSFORM = mat4(
		vec4(1.0, 0.0, 0.0, 0.0),
		vec4(0.0, 1.0, 0.0, 0.0),
		vec4(0.0, 0.0, 1.0, 0.0),
		vec4(pos, 1.0)
	);

	// 根据当前速度（洛伦兹导数）映射颜色，速度低偏蓝，速度高偏红
	vec3 vel = lorenz(pos);
	float speed = length(vel);
	vec3 col = mix(vec3(0.2, 0.5, 1.0), vec3(1.0, 0.2, 0.2), clamp(speed / 50.0, 0.0, 1.0));
	COLOR = vec4(col, 1.0);
}