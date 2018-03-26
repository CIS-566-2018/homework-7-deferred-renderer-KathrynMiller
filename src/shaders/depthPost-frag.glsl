#version 300 es
precision highp float;

in vec2 fs_UV;
out vec4 out_Col;

uniform vec4 u_ExtraData;

uniform vec2 u_Dimensions;
uniform sampler2D depth;
uniform sampler2D u_frame;
uniform float u_Time;

float width = 1087.0;
float height = 837.0;

const float PI = 3.14159;
const float E = 2.71828;
const float SIGMA = 1.0;

/*
void createKernel(inout float kernel[225.0], float size) {
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
*/
void main() {
	float focalLength = u_ExtraData[0];
	vec4 color = vec4(0.0, 0.0, 0.0, 1.0);
	//vec4 color = texture(u_frame, fs_UV);
	float depth = texture(depth, fs_UV)[3];
	float kernel[int(225.0)];
	float depthScale = 0.0;
	float kernelSize = 0.0;
	if(depth > focalLength) {
		depthScale = 1.0 - ((depth - focalLength) / 1000.);
		kernelSize = 15.0 * depthScale;
		if(depth > 900.0) {
			kernelSize = 15.0;
		}
	}
	//createKernel(kernel, kernelSize);
	for(float i = -kernelSize / 2.0; i < kernelSize / 2.0; i++) {
		for(float j = -kernelSize / 2.0; j < kernelSize / 2.0; j++) {
			vec2 offset = vec2(i / u_Dimensions[0], j / u_Dimensions[1]); // -1 to 1
			//float scale = kernel[int((i + kernelSize / 2.0) * 21.0 + (j + kernelSize /2.0))];
			color += texture(u_frame, fs_UV + offset);
		}
	}
	if(kernelSize > 0.0) {
		out_Col = vec4(color.xyz / (kernelSize * kernelSize), 1.0);
	} else {
		out_Col = texture(u_frame, fs_UV);
	}
	
	//out_Col = color;
}
