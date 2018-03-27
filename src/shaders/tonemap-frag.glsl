#version 300 es
precision highp float;

in vec2 fs_UV;
out vec4 out_Col;

uniform sampler2D u_frame;
uniform float u_Time;


void main() {

/*//Jim Hejl and Richard Burgess-Dawson
   vec3 texColor = vec3(texture(u_frame, fs_UV));
   texColor *= 16.0;  // Hardcoded Exposure Adjustment
   vec3 x = max(vec3(0.0), texColor - vec3(0.004));
   vec3 retColor = vec3(x * (6.2 * x + .5)) / (x * (6.2 * x + 1.7) + 0.06);
   out_Col = vec4(retColor,1);
*/

// reinhard
	vec3 texColor = vec3(texture(u_frame, fs_UV));
   texColor *= 16.0;  // Hardcoded Exposure Adjustment
   texColor = texColor / (vec3(1.0) + texColor);
   vec3 retColor = pow(texColor, vec3(1.0 / 2.2));
   out_Col = vec4(retColor, 1.0);
}
