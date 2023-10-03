float CircleShape(vec2 position, float radius)
{
    return step(radius, length(position - vec2(0.5)));
}

void main()
{
    vec2 position = gl_FragCoord.xy/iResolution.xy;

    vec3 colour = vec3(0.0);

    float circle = CircleShape(position, 0.1);

    colour = vec3(circle);

    gl_FragColor = vec4(colour, 1.0);
}