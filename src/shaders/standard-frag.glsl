#version 300 es
precision highp float;

in vec4 fs_Pos;
in vec4 fs_Nor;
in vec4 fs_Col;
in vec2 fs_UV;
in float fs_Type;
uniform vec4 u_Color;

out vec4 fragColor[3]; // The data in the ith index of this array of outputs
                       // is passed to the ith index of OpenGLRenderer's
                       // gbTargets array, which is an array of textures.
                       // This lets us output different types of data,
                       // such as albedo, normal, and position, as
                       // separate images from a single render pass.

uniform sampler2D tex_Color;


void main() {
    // TODO: pass proper data into gbuffers
    // Presently, the provided shader passes "nothing" to the first
    // two gbuffers and basic color to the third.

    vec3 col = texture(tex_Color, fs_UV).rgb;
    if(fs_Type == 2.0) {
        col = vec3(u_Color);
    }
    // if using textures, inverse gamma correct
    col = pow(col, vec3(2.2));

    // normal and depth value in w
    fragColor[0] = fs_Nor;
    // 1 since mesh overlaps
    fragColor[1] = vec4(1.0);
    // albedo
    fragColor[2] = vec4(col, 1.0);
}
