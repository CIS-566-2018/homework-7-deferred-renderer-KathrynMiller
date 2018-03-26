#version 300 es
precision highp float;

in vec2 fs_UV;
out vec4 out_Col;

uniform sampler2D originalImage;
uniform sampler2D u_frame;
uniform float u_Time;

// Interpolate between regular color and channel-swizzled color
// on right half of screen. Also scale color to range [0, 5].
void main() {
    vec4 color;
	vec4 originalCol = texture(originalImage, fs_UV);
    vec4 bloomCol = texture(u_frame, fs_UV);
	color = originalCol + bloomCol;
	//out_Col = vec4(color.xyz, 1.0);
    out_Col = color;
}
