/*
A Fractal pattern using multiple circles and a shifting colour palette
*/


// Colour Palette generation function
vec3 palette(float t)
{
    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(0.263, 0.416, 0.557);

    return a + b * cos(6.28318 * (c * t + d));
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y;
    vec2 uv0 = uv; 
    vec3 finalColour = vec3(0.0);

    for(float i = 0.0; i < 4.0; i++)
    {
        uv = fract(uv * 1.4) - 0.5;     //The fract function is used to create the multiple repeating patterns.

        float dist = length(uv) * exp(-length(uv0));

        vec3 colour = palette(length(uv0) + i * 0.4 + iTime * 0.6);

        dist = sin(dist * 8.0 - iTime)/8.0; // The sin function is used to create the circles. Refer to Shader One.glsl for more information
        dist = abs(dist); // The absolute value is take so that the inside of the sahpe also returns a positive value
        dist = pow(0.01 / dist, 1.4); // The pow function is used to increase the contrast bewteen the circles and the background

        finalColour += dist * colour; //doing this ensures that colour variables isn't changed directly
    }

    fragColor = vec4(finalColour, 1);
}