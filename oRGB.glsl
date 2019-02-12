/*
This is a GLSL implementation of
oRGB: A Practical Opponent Color Space for Computer Graphics
    invented by: Margarita Bratkova, Solomon Boulos and Peter Shirley.

This implementation is based on the original paper:
	https://graphics.stanford.edu/~boulos/papers/orgb_sig.pdf
*/

/*
  USAGE:
    Convert a color to oRGB:
      vec3 orbgColor = convertRgbToORGB(col);
    Manipulate the color, for example:
      orbgColor.g -= 0.25;  // <- shift te image towards blueish tint
    Conver our oRGB color back to RGB:
      vec3 rgbColor = convertOrgbToRgb(orbgColor);
      
  Check here for a live example:
    https://www.shadertoy.com/view/WdS3DV
*/


const float PI = 3.1415926535897932384626433832795;
const float PI_2 = 1.57079632679489661923;
const float PI_3 = 1.047197551196598;

// Linear transorm from R'G'B' to L'C'C'
vec3 transformRGBToLCC(in vec3 rgbColor)
{
  return vec3(
    0.299 * rgbColor.r + 0.587 * rgbColor.g + 0.114 * rgbColor.b,
    0.5 * (rgbColor.r + rgbColor.g) - rgbColor.b,
    0.866 * (rgbColor.r - rgbColor.g)
  );
}

// Linear transorm from L'C'C' to R'G'B'
vec3 transformLCCToRGB(in vec3 lccColor)
{
  // lccColor = (Luma, C1, C2)
  return vec3(
    lccColor.r + 0.114 * lccColor.g + 0.7436 * lccColor.b, 
    lccColor.r + 0.114 * lccColor.g - 0.4111 * lccColor.b, 
    lccColor.r - 0.886 * lccColor.g + 0.1663 * lccColor.b
  );
}

// Non-uniform rotation around the luma axis
void transformAngle(inout float angle)
{
  // The vector needs to be symmetrical around the yellow-blue axis
  // we need to keep the sign of the angle
  float signAngle = sign(angle);
  angle *= signAngle;
  if(angle < PI_3) 
    angle *= 1.5;
  else if(PI >= angle  && angle  >= PI_3) 
    angle = PI_2 + 0.75 * (angle - PI_3);
  angle *= signAngle;
}

// Non-uniform rotation around the luma axis - reverse.
void untransformAngle(inout float angle)
{
  // The vector needs to be symmetrical around the yellow-blue axis
  // we need to keep the sign of the angle
  float signAngle = sign(angle);
  angle *= signAngle;
  if(angle < PI_2) {
    angle = angle * 2.0 / 3.0;
  } else if (PI >= angle && angle >= PI_2) {
    angle = PI_3 + (angle - PI_2) * 4.0 / 3.0;
  }
  angle *= signAngle;
}

// RGB to oRGB conversion
vec3 convertRgbToORGB(in vec3 rgbColor)
{
  // Convert from RGB to LCC
  vec3 orgb = transformRGBToLCC(rgbColor);
  // Calculate angle
  float angle = atan(orgb.b, orgb.g);
  // Non-uniform rotation around Luma axis
  transformAngle(angle);
  // Calculate length of the vector so we can apply the new angle
  float len = min(length(vec2(orgb.gb)), 1.0);
  // Apply the new angle on yellow-blue and ed-green channels
  orgb.g = cos(angle) * len;
  orgb.b = sin(angle) * len;
  return orgb;
}

// oRGB to RGB conversion
vec3 convertOrgbToRgb(in vec3 orgbColor)
{
  vec3 lccColor = orgbColor;
  float angle = atan(orgbColor.b, orgbColor.g);
  // Reverse the non-uniform rotation around Luma axis
  untransformAngle(angle);

  // Get length of the vector that is formed by Cyb and Crg, so we can apply the new angle
  float len = length(orgbColor.gb);

  // Apply the new angle to both channels (yellow-blue, red-green)
  lccColor.g = cos(angle) * len;
  lccColor.b = sin(angle) * len;
  // Transform back to RGB.
  vec3 rgbColor = transformLCCToRGB(lccColor);
  rgbColor = clamp(rgbColor, 0.0, 1.0);
  return rgbColor;
}
