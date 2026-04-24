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
vec3 rk4(vec3 pos, float step) {
	vec3 k1 = lorenz(pos);
	vec3 mid = pos + 0.5 * step * k1;
	vec3 k2 = lorenz(mid);
	mid = pos + 0.5 * step * k2;
	vec3 k3 = lorenz(mid);
	vec3 end_p = pos + step * k3;
	vec3 k4 = lorenz(end_p);
	return pos + (step / 6.0) * (k1 + 2.0*k2 + 2.0*k3 + k4);
}

void start() {
	vec3 base_offset = texture(noise,vec2(sin(float(RANDOM_SEED)),cos(float(RANDOM_SEED)))).rgb;
	TRANSFORM[3].xyz = base_offset + vec3(-0.5);
	COLOR = vec4(1.0);// 初始颜色
}

void process() {
	vec3 pos = TRANSFORM[3].xyz;
	float remaining = DELTA;          // 本帧剩余时间
	// 子步循环，确保无论帧率如何都使用固定步长 h
	for (int i = 0; i < 200; i++) {  // 200 是安全上限，避免死循环
		if (remaining <= 0.0) break;
		float step = min(h, remaining);
		pos = rk4(pos, step);
		remaining -= step;
	}
	TRANSFORM[3].xyz = pos;           // 更新粒子位置
	VELOCITY = vec3(0.0);             // 禁止系统内置运动干扰
}