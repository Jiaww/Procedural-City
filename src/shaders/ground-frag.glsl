#version 300 es

// This is a fragment shader. If you've opened this file first, please
// open and read lambert.vert.glsl before reading on.
// Unlike the vertex shader, the fragment shader actually does compute
// the shading of geometry. For every pixel in your program's output
// screen, the fragment shader is run for every bit of geometry that
// particular pixel overlaps. By implicitly interpolating the position
// data passed into the fragment shader by the vertex shader, the fragment shader
// can compute what color to apply to its pixel based on things like vertex
// position, light position, and vertex color.
precision highp float;

uniform vec4 u_Color; // The color with which to render this instance of geometry.
uniform sampler2D u_DiffuseMap;
uniform int u_ShowDensity;

// These are the interpolated values out of the rasterizer, so you can't know
// their specific values without knowing the vertices that contributed to them
in vec4 fs_Nor;
in vec4 fs_LightVec;
in vec4 fs_Col;
in vec2 fs_Uv;

out vec4 out_Col; // This is the final output color that you will see on your
                  // screen for the pixel that is currently being processed.
const vec4 fogColor = vec4(0.9, 0.9, 0.9, 1.0);

void main()
{
    // Material base color (before shading)
        //vec4 diffuseColor = vec4(0.32,0.2,0.03,1.0);
        vec4 diffuseColor = texture(u_DiffuseMap, fs_Uv);

        // Calculate the diffuse term for Lambert shading
        float diffuseTerm = dot(normalize(fs_Nor), normalize(fs_LightVec));
        // Avoid negative lighting values
        diffuseTerm = clamp(diffuseTerm, 0.0, 1.0);
        float ambientTerm = 0.2;

        float lightIntensity = diffuseTerm + ambientTerm;   //Add a small float value to the color multiplier
                                                            //to simulate ambient lighting. This ensures that faces that are not
                                                            //lit by our point light are not completely black.

        //fog
        float dist = gl_FragCoord.z / gl_FragCoord.w;
        float fogAmount = 1.0 /exp(dist * 0.01 * dist * 0.01);
        fogAmount = clamp(fogAmount, 0.0, 1.0);

        // Compute final shaded color
        if (u_ShowDensity == 1)
            out_Col = vec4(0.0, 0.0, 0.0, 1.0);
        else 
            out_Col = mix(vec4(0.8, 0.8, 0.8, 1.0), fogColor, 1.0 - fogAmount);
}
