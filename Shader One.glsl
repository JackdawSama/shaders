/*
The following file uses Better Comments extension. Please be aware that some comments my look weird without the extension.
THEY ARE NOT PART OF GLSL SYNTAX.
*/

/*
Thefollowing is a GLSL shader file that is meant to explain how shader files are set up and how to work with them.
There will be multiple lines of code commented out but make sure to read the comments as they explain what the code does.
The code that is not commented out is the code that is being used.
*/

/* 
Concepts to be aware of before reading the code:
- Swizzling
*/

// for better explanation follow : https://www.youtube.com/watch?v=f4s1h2YETNY&t=193s

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    /* 
    In the following snippet, the shader is normalised which means it falss in the range of 0 to 1.
    The center of the canvas is (0.5, 0.5) but the origin of our coordinates is (0,0) in this case.
    */

    // Normalized pixel coordinates (from 0 to 1)
    //? vec2 uv = fragCoord / iResolution.xy;   // iResolution is a vec3 that's a constant. iResolution.xy is the swizzled version of iResolution

    // fragColor = vec4(uv.x, uv.y, 0, 1.0); 
    //? fragColor = vec4(uv, 0, 1.0);   // This is the same as the line above. It merges the first two channels of uv into one

    /* 
    In the following snippet, the normalised space is set up such that the range is from (-1, 1).
    This is done so that the center of the canvas and the origin of our coordinate space are the same.
    */

    //? vec2 uv = fragCoord / iResolution.xy;
    
    //? uv = uv - 0.5;  //This shifts the origion of the coordinate to the center of the canvas
    //? uv = uv * 2.0;

    //? fragColor = vec4(uv, 0, 1);

    // The above code snippet can be condensed as follows

    vec2 uv = (fragCoord / iResolution.xy) * 2.0 - 1.0;

    fragColor = vec4(uv, 0, 1);
    
}