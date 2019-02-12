# orgb-glsl
This is an OpenGL Shader implementation of 
#### oRGB: A Practical Opponent Color Space for Computer Graphics
based on the paper by Margarita Bratkova, Solomon Boulos and Peter Shirley.

oRGB is based on the opponent color theory. It's designed specifically for computer graphics, but its natural axes allow HSV-like intuitive color selection. 
Read the paper [here](https://graphics.stanford.edu/~boulos/papers/orgb_sig.pdf) to learn more about the oRGB color space, its advantages, limitations and possible areas of usage.

### Usage:
The oRGB.glsl shader contains functions for coverting between oRGB and RGB color spaces.
* Convert a color to oRGB:
  ```
  vec3 orbgColor = convertRgbToORGB(col);
  ```
* Change the oRGB color, like:
  ```
  // This will double the contrast of reds and greens
  orbgColor.b *= 2.0;
  // This will halve the contrast of yellows and blues
  orbgColor.g *= 0.5;
  // This will set a 130 % contrast to the image
  orbgColor.r = (orbgColor.r - 0.5) * 1.3 + 0.5;

  ```
* Convert back to RGB:
  ```
  vec3 rgbColor = convertOrgbToRgb(orbgColor);
  ```
[Click here to see it in aciton on ShaderToy.com](https://www.shadertoy.com/view/WdS3DV).
