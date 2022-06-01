varying vec2 v_vTexCoord;

uniform float u_fTexel;
uniform float u_fValue;

#pragma include("HSV.xsh", "glsl")
/// @desc Converts RGB color to HSV.
/// @source http://dystopiancode.blogspot.com/2012/06/hsv-rgb-conversion-algorithms-in-c.html
vec3 xRGBToHSV(vec3 rgb)
{
	float r = rgb.r;
	float g = rgb.g;
	float b = rgb.b;

	vec3 color = vec3(0.0, 0.0, 0.0);

	if (r < 0.0 || r > 1.0
		|| g < 0.0 || g > 1.0
		|| b < 0.0 || b > 1.0)
	{
		return color;
	}

	float M = max(r, max(g, b));
	float m = min(r, min(g, b));
	float c = M - m;

	color.b = M;

	if (c != 0.0)
	{
		if (M == r)
		{
			color.r = mod(((g - b) / c), 6.0);
		}
		else if (M == g)
		{
			color.r = (b - r) / c + 2.0;
		}
		else
		{
			color.r = (r - g) / c + 4.0;
		}
		color.r *= 60.0;
		color.g = c / color.b;
	}

	return color;
}

/// @desc Converts HSV color to RGB.
/// @source http://dystopiancode.blogspot.com/2012/06/hsv-rgb-conversion-algorithms-in-c.html
vec3 xHSVToRGB(vec3 hsv)
{
	float h = hsv.x;
	float s = hsv.y;
	float v = hsv.z;

	if (h < 0.0 || h > 360.0
		|| s < 0.0 || s > 1.0
		|| v < 0.0 || v > 1.0)
	{
		return vec3(0.0, 0.0, 0.0);
	}

	float c = v * s;
	float x = c * (1.0 - abs(mod(h / 60.0, 2.0) - 1.0));
	float m = v - c;

	if (h >= 0.0 && h < 60.0)
	{
		return vec3(c + m, x + m, m);
	}
	if (h >= 60.0 && h < 120.0)
	{
		return vec3(x + m, c + m, m);
	}
	if (h >= 120.0 && h < 180.0)
	{
		return vec3(m, c + m, x + m);
	}
	if (h >= 180.0 && h < 240.0)
	{
		return vec3(m, x + m, c + m);
	}
	if (h >= 240.0 && h < 300.0)
	{
		return vec3(x + m, m, c + m);
	}
	if (h >= 300.0 && h < 360.0)
	{
		return vec3(c + m, m, x + m);
	}
	return vec3(m, m, m);
}
// include("HSV.xsh")

#pragma include("Math.xsh", "glsl")
#define X_PI   3.14159265359
#define X_2_PI 6.28318530718

/// @return x^2
#define xPow2(x) ((x) * (x))

/// @return x^3
#define xPow3(x) ((x) * (x) * (x))

/// @return x^4
#define xPow4(x) ((x) * (x) * (x) * (x))

/// @return x^5
#define xPow5(x) ((x) * (x) * (x) * (x) * (x))

/// @return arctan2(x,y)
#define xAtan2(x, y) atan(y, x)

/// @return Direction from point `from` to point `to` in degrees (0-360 range).
float xPointDirection(vec2 from, vec2 to)
{
	float x = xAtan2(from.x - to.x, from.y - to.y);
	return ((x > 0.0) ? x : (2.0 * X_PI + x)) * 180.0 / X_PI;
}
// include("Math.xsh")

void main()
{
	vec2 pos = v_vTexCoord - vec2(0.5);
	vec3 hsv = vec3(
		xPointDirection(v_vTexCoord, vec2(0.5)),
		clamp(length(pos) / 0.5, 0.0, 1.0),
		u_fValue
	);
	gl_FragColor.rgb = xHSVToRGB(hsv);
	gl_FragColor.a = smoothstep(u_fTexel * 1.5, 0.0, length(pos) - 0.49);
}