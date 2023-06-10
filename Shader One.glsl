/*
Thefollowing is a GLSL shader file that is meant to explain how shader files are set up and how to work with them.
There will be multiple lines of code commented out but make sure to read the comments as they explain what the code does.
The code that is not commented out is the code that is being used.
*/

/* 
Concepts to be aware of before reading the code:
- Swizzling
*/

/*
IMPORTANT NOTE : Functions must always be defined before the mainImage function.
*/

// for better explanation follow : https://www.youtube.com/watch?v=f4s1h2YETNY&t=193s

/*
The following function was obtained from a resource from the video linked above.
It generates a colour palette using trignometery.
*/

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
    /* 
    In the following snippet, the shader is normalised which means it falss in the range of 0 to 1.
    The center of the canvas is (0.5, 0.5) but the origin of our coordinates is (0,0) in this case.
    */

    /* Normalized pixel coordinates (from 0 to 1) */
    // vec2 uv = fragCoord / iResolution.xy;   // iResolution is a vec3 that's a constant. iResolution.xy is the swizzled version of iResolution

    // fragColor = vec4(uv.x, uv.y, 0, 1.0); 
    // fragColor = vec4(uv, 0, 1.0);   // This is the same as the line above. It merges the first two channels of uv into one

    /* 
    In the following snippet, the normalised space is set up such that the range is from (-1, 1).
    This is done so that the center of the canvas and the origin of our coordinate space are the same.
    */

    // vec2 uv = fragCoord / iResolution.xy;
    
    // uv = uv - 0.5;  //This shifts the origion of the coordinate to the center of the canvas
    // uv = uv * 2.0;

    // fragColor = vec4(uv, 0, 1);

    /* The above code snippet can be condensed as follows */

    // vec2 uv = (fragCoord / iResolution.xy) * 2.0 - 1.0;

    // fragColor = vec4(uv, 0, 1);

    /* Now we will be using the above base to create a pattern */

    // vec2 uv = fragCoord / iResolution.xy * 2.0 - 1.0;
    // uv.x *= iResolution.x / iResolution.y;  // This is done so that the pattern is not stretched out along the X axis

    /* The above code snippet can be condensed as follows */

    vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y;
    vec2 uv0 = uv; // caches the value of uv so that we can hold the original coordinate space and not have it altered
    vec3 finalColour = vec3(0.0);

    /*
    The fract function is used to create repeating patterns here.
    It functions like a Sawtooth Wave
    */

    //uv *= 3.0;
    //uv = fract(uv); // The fract function returns the fractional part of the argument. In this case it returns the fractional part of uv
    //uv -= 0.5; // This is done to center the pattern

    /*
    The above lines have been condensed into the following line of code for brevity
    */

    /*
    By putting the whole function into a for looop and changing the iteration we cna achieve repeating fractals which create interesting patterns
    */

    for(float i = 0.0; i < 4.0; i++)
    {
        uv = fract(uv * 1.4) - 0.5;

        //float dist = length(uv); // The length function calculates the distance from the origin of the coordinate space to the point uv

        float dist = length(uv) * exp(-length(uv0)); // This is done to create a gradient. The lenght is multipled by the exponential of the negative length of the original coordinate space

        //vec3 colour = vec3(1.0, 0.0, 0.0);

        /*
        Instead of af fixed colur, we'll be using a function to create a colour palette.
        */

        //vec3 colour = palette(dist); // The palette function is defined at the top of the code.

        /*
        The palette function can be made to change using the iTime variable.
        */

        //vec3 colour = palette(dist + iTime); // The iTime variable is a vec3 that's a constant

        vec3 colour = palette(length(uv0) + i * 0.4 + iTime * 0.6); // This line makes the palette change with respect to the coordinate space and not the local space of each pattern

        //dist -= 0.5; // Sine Distance Function, where the radius of the circle is 0.5

        dist = sin(dist * 8.0 - iTime)/8.0; // The sine function is used instead of the previous line of code to a pattern. 
        
        /*
        Increasing the number in the denominator in the above expressions will increase the sharpness of the circles and similarly,
        changing the numerator will change the number of circles.
        
        Introducing the iTime variable to the above expression will make the pattern move inward or outward based on the sign.
        */ 

        /*
        An SDF is a function that takes a point as input and returns the shortest distance from that point to some surface.
        Points within the shape will always be negative and points outside the shape will always be positive.
        Points on the edge of the shape will be 0.
        */

        dist = abs(dist); // The absolute function  makes the distance on the inside of the shape positive as well

        //dist = step(0.1, dist); // The step function returns 1 if the first argument is greater than the second argument and 0 otherwise

        //dist = smoothstep(0.0, 0.1, dist); // The smoothstep function is similar to the step function but it interpolates between 0 and 1

        /*
        The smoothstep function is not used and instead the 1/x function is used to help create effects using neon colours.
        */

        //dist = 0.01 / dist;

        /*
        In the above case the distance is 0.01 instead of 1/x because of the absolute function and our normalised range. Due to this 
        it'll always give the result of white. To combat this we choose valuse between 0 to 1 so that we can get the desired effect. 
        */

        dist = pow(0.01 / dist, 1.4); // The pow function is used to increase the contrast bewteen the circles and the background

        //colour = dist * colour;

        finalColour += dist * colour; //doing this ensures that colour variables isn't changed directly
    }

    fragColor = vec4(finalColour, 1);    
}