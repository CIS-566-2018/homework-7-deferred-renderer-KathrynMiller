#version 300 es
precision highp float;

in vec2 fs_UV;
out vec4 out_Col;

uniform sampler2D u_frame;
uniform float u_Time;
uniform vec2 u_Dimensions;

// if luminance is above value, return color,
// otherwise return black
void main() {
	vec4 color = texture(u_frame, fs_UV);
	float luminance = 0.21 * color[0] + 0.72 * color[1] + 0.07 * color[2]; //[0, 1]

	if(luminance > .55) {
		out_Col = vec4(color.xyz, 1.0);
	} else {
		out_Col = vec4(0.0);
	}
	
}
