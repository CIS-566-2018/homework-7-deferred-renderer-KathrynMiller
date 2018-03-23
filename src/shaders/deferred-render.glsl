#version 300 es
precision highp float;

#define EPS 0.0001
#define PI 3.1415962

in vec2 fs_UV;
out vec4 out_Col;

uniform sampler2D u_gb0;
uniform sampler2D u_gb1;
uniform sampler2D u_gb2;

uniform float u_Time;

uniform mat4 u_View;
uniform vec4 u_CamPos;

vec4 fs_LightVec = vec4(4, 4, 4, 1);   


void main() { 
	// read from GBuffers (normal, mesh overlap, color)
	vec3 fs_Nor = vec3(texture(u_gb0, fs_UV));
	vec4 meshOverlap = texture(u_gb1, fs_UV);
	// base color
	vec4 diffuseColor = texture(u_gb2, fs_UV);
	
	vec4 H = normalize((u_CamPos + fs_LightVec) / 2.0);
	float specularIntensity = max(pow(dot(H, vec4(fs_Nor, 0.0)), 20.0), 0.0);

	// lambertian term for blinn 
	float diffuseTerm = dot(normalize(vec4(fs_Nor, 0.0)), normalize(fs_LightVec));
	diffuseTerm = clamp(diffuseTerm, 0.0, 1.0);

	float ambientTerm = 0.2;

	float lightIntensity = diffuseTerm + ambientTerm; 
	 if(meshOverlap == vec4(0.0)) {
		out_Col = diffuseColor * (specularIntensity + lightIntensity);
	 } else {
		 out_Col = vec4(1.0, 0.1, 0.1, 1.0);
	 }
	
}