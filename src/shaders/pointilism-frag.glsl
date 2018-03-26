#version 300 es
precision highp float;

in vec2 fs_UV;
out vec4 out_Col;

uniform vec2 u_Dimensions;
uniform sampler2D u_frame;
uniform float u_Time;

uniform vec4 u_ExtraData;

vec3 contrastColor(vec3 color);

//returns value in range [-1, 1]
vec2 random2( vec2 p ) {
    return fract(sin(vec2(dot(p,vec2(127.1,311.7)),dot(p,vec2(269.5,183.3))))*43758.5453);
}

void main() {

float maxDotRadius = u_ExtraData[0];
float numCells = u_ExtraData[1];

 vec4 color = texture(u_frame, fs_UV);
 float luminance = 0.21 * color[0] + 0.72 * color[1] + 0.07 * color[2]; //[0, 1]
 // set to white default
 color = vec4(1.0);

 vec2 cellUV = fs_UV * numCells; // width height space
 vec2 cellID = floor(cellUV);  // bottom left corner & width-height space

 // iterate over 3x3 matrix of pixels
	for(float i = -1.0; i <= 1.0; i ++) {
        for (float j = -1.0; j <= 1.0; j++) {
			// currently searched lower left point
            vec2 curr = vec2(cellID.x + i, cellID.y + j); // width, height space
			// offset within current cell (center of prospective dot)
            vec2 dotCenter = curr + (float(random2(curr) + 1.0) / 2.0); // width, height space
			// color at offset point
			vec3 cellCol = contrastColor(vec3(texture(u_frame, dotCenter / numCells)));
			float l = 0.21 * cellCol[0] + 0.72 * cellCol[1] + 0.07 * cellCol[2];
			// radius of dot at offset point
			float currRad = (maxDotRadius + (random2(curr).y / 2.0)) * (1.0 -l);
			if(length(dotCenter - cellUV) < currRad) {
				color = vec4(0.0, 0.0, 0.0, 1.0);
				break;
			}
        }
    }

 out_Col = color;
}

vec3 contrastColor(vec3 color) {
	float contrast = -30.0;
	float factor = ((259.0 * (contrast + 255.0)) / (255.0 * (259.0 - contrast)));
	float r = clamp(color[0] * factor, 0.0, 1.0);
	float g = clamp(color[1] * factor, 0.0, 1.0);
	float b = clamp(color[2] * factor, 0.0, 1.0);
	return vec3(r, g, b);
}
