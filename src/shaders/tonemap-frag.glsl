#version 300 es
precision highp float;

in vec2 fs_UV;
out vec4 out_Col;

uniform sampler2D u_frame;
uniform float u_Time;


void main() {
	// TODO: proper tonemapping
	// This shader just clamps the input color to the range [0, 1]
	// and performs basic gamma correction.
	// It does not properly handle HDR values; you must implement that.

/*
   vec3 texColor = vec3(texture(u_frame, fs_UV));
   texColor *= 16.0;  // Hardcoded Exposure Adjustment
   vec3 x = max(vec3(0.0), texColor - vec3(0.004));
   vec3 retColor = vec3(x * (6.2 * x + .5)) / (x * (6.2 * x + 1.7) + 0.06);
   out_Col = vec4(retColor,1);
*/

	vec3 texColor = vec3(texture(u_frame, fs_UV));
   texColor *= 16.0;  // Hardcoded Exposure Adjustment
   texColor = texColor / (vec3(1.0) + texColor);
   vec3 retColor = pow(texColor, vec3(1.0 / 2.2));
   out_Col = vec4(retColor, 1.0);




	// vec3 color = texture(u_frame, fs_UV).xyz;
	// color = min(vec3(1.0), color);

	// // gamma correction
	// color = pow(color, vec3(1.0 / 2.2));
	// out_Col = vec4(color, 1.0);
}
