#version 300 es
precision highp float;

#define EPS 0.0001
#define PI 3.1415962
const float TWO_PI = 6.28318530718;

in vec2 fs_UV;
out vec4 out_Col;

uniform sampler2D u_gb0;
uniform sampler2D u_gb1;
uniform sampler2D u_gb2;

uniform float u_Time;

uniform mat4 u_View;
uniform vec4 u_CamPos;

float width = 1087.0;
float height = 837.0;
const vec2 cellSizePixels = vec2(192.,192.);

const float numCells = 10.0;
vec3 backCol = vec3(1.0, 0.1, 0.1);

uniform mat4 u_ViewProj;

vec4 fs_LightVec = vec4(4, 4, 4, 1);   
vec4 skyShader();
float fbm(const in vec2 uv);
float fbm(const in vec3 uv);
float noise(in vec2 uv);


const vec3 sky[5] = vec3[](
        vec3(1.0, 0.0, 0.0) / 255.0,
vec3(0.0, 1.0, 0.0) / 255.0,
vec3(0.0, 0.0, 1.0) / 255.0,
vec3(1.0, 0.0, 1.0) / 255.0,
vec3(0.0, 1.0, 1.0) / 255.0);

void main() { 
	// read from GBuffers (normal, mesh overlap, color)
	vec3 fs_Nor = vec3(texture(u_gb0, fs_UV));
	vec4 meshOverlap = texture(u_gb1, fs_UV);
	 vec4 diffuseColor = vec4((texture(u_gb2, fs_UV)).xyz, 1.0);

	// lambertian term for blinn 
	float diffuseTerm = dot(normalize(vec4(fs_Nor, 0.0)), normalize(fs_LightVec));
	diffuseTerm = clamp(diffuseTerm, 0.0, 1.0);

	float ambientTerm = 0.2;

	float lightIntensity = diffuseTerm + ambientTerm; 
	 if(meshOverlap == vec4(1.0)) {
		out_Col = diffuseColor * lightIntensity;
	 } else {
		 out_Col = skyShader();
	 }
	
}

vec2 q(vec2 x, vec2 p)
{
    return floor(x / p) * p;
}

float rand(vec2 co){
  return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

vec3 rand3(vec2 p)
{
    vec3 p2 = vec3(p, rand(p));
    return
        fract(sin(vec3(
            dot(p2,vec3(127.1,311.7,427.89)),
            dot(p2,vec3(269.5,183.3,77.24)),
            dot(p2,vec3(42004.33,123.54,714.24))
            ))*43758.5453);
}

vec4 skyShader() {
	// similar cell structure of pointilism
	// random square size for bottom left cell corners 
    vec2 uv = fs_UV;
    vec2 cellSizePixels = vec2(192.,192.);
    vec2 cellSize = vec2(cellSizePixels / width);
	
	vec2 cellOrig;
    float cellID;
    float edgeSizePixels = 7.;

	for(float i = 0.; i < 5.0; i++)
    {
        cellSize *= .5; // split cellSize in half each iteration
        edgeSizePixels *= .5; // " " edge width
        cellOrig = q(uv, cellSize); // square this pixel belongs to
        cellID = rand(cellOrig); // random number associated with this cell
        if(i / 5.0 > sin(cellID * 6.28 + u_Time * .2) * .5 + .3) // stop if box is getting too small
            break;
    }

	float distToCenter = distance(uv, cellOrig + cellSize / 2.0)/ (length(cellSize) / 2.0);

	vec3 cellColor = rand3(cellOrig);
    vec4 color = vec4(cellColor.rgbb) * .3;
    color *= (1.0 - distToCenter) * .4;
	color *= 10.0;
	return color;

}