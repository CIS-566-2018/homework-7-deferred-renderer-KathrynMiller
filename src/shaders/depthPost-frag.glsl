#version 300 es
precision highp float;

in vec2 fs_UV;
out vec4 out_Col;

uniform sampler2D depth;
uniform sampler2D u_frame;
uniform float u_Time;

float width = 1087.0;
float height = 837.0;

const float PI = 3.14159;
const float E = 2.71828;
const float SIGMA = 1.0;
const float focalLength = 32.0;

void createKernel(inout float kernel[225], float size) {
	for(float i = -size / 2.0; i < size / 2.0; i++) {
		for(float j = -size / 2.0; j < size / 2.0; j++) {
			float x = i + size / 2.0;
			float y = j + size / 2.0;
			float dist = sqrt(pow(x, 2.0) + pow(y, 2.0));
			float gaussScale = 1.0 / (SIGMA * sqrt(2.0 * PI))  * pow(E, -.5 * pow(dist / SIGMA, 2.0));
			kernel[int((i + size / 2.0) * 21.0 + (j + size /2.0))] = gaussScale;
		}
	}
}

void main() {
	vec4 color = vec4(0.0, 0.0, 0.0, 1.0);
	float depth = texture(depth, fs_UV)[3];
	float kernel[225];
	float kernelSize = 15.0;
	createKernel(kernel, kernelSize);
	for(float i = -kernelSize / 2.0; i < kernelSize / 2.0; i++) {
		for(float j = -kernelSize / 2.0; j < kernelSize / 2.0; j++) {
			vec2 offset = vec2(i / width, j / height); // -1 to 1
			//float scale = kernel[int((i + kernelSize / 2.0) * 21.0 + (j + kernelSize /2.0))];
			color += texture(u_frame, fs_UV + offset);
		}
	}
	out_Col = vec4(color.xyz / (kernelSize * kernelSize), 1.0);
}
