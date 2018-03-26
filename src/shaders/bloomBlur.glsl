#version 300 es
precision highp float;

in vec2 fs_UV;
out vec4 out_Col;

uniform vec2 u_Dimensions;
uniform sampler2D u_frame;
uniform float u_Time;

// Interpolate between regular color and channel-swizzled color
// on right half of screen. Also scale color to range [0, 5].
void main() {
	vec4 color = texture(u_frame, fs_UV);
    float kernelSize = 15.0;
	for(float i = -kernelSize / 2.0; i < kernelSize / 2.0; i++) {
		for(float j = -kernelSize / 2.0; j < kernelSize / 2.0; j++) {
			vec2 offset = vec2(i / u_Dimensions[0], j / u_Dimensions[1]); // -1 to 1
			//float scale = kernel[int((i + kernelSize / 2.0) * 21.0 + (j + kernelSize /2.0))];
			color += texture(u_frame, fs_UV + offset);
		}
	}
		out_Col = vec4(color.xyz / (kernelSize * kernelSize), 1.0);
}
