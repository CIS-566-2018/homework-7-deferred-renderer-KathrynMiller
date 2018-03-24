#version 300 es
precision highp float;

in vec2 fs_UV;
out vec4 out_Col;

uniform sampler2D u_gb1;
uniform sampler2D u_frame;
uniform float u_Time;

float width = 1087.0;
float height = 837.0;

const float PI = 3.14159;
const float E = 2.71828;
const float SIGMA = 1.0;

void createKernel(inout float kernel[11], float size) {
	// set front end elements to be 0 if size < 11
	for(float i = 0.0; i < size / 2.0; i++) {
		kernel[int(i)] = 0.0;
	}
	for(float x = -size / 2.0; x < size / 2.0; x++) {
		float gausScale = (1.0 / sqrt(2.0 * PI * pow(SIGMA, 2.0))) * pow(E, -pow(x, 2.0) / (2.0 * pow(SIGMA, 2.0)));
		kernel[int(x)] = gausScale;
	}
		for(float i = size / 2.0; i < 11.0; i++) {
		kernel[int(i)] = 0.0;
	}
}

void main() {
	vec3 color = vec3(texture(u_frame, fs_UV));
	float depth = texture(u_frame, fs_UV)[3];
	//float kernelSize = 
	//for()
	out_Col = vec4(color, 1.0);
}
