varying vec2 v_vTexcoord;
varying vec4 v_vColour;

#define PI 3.14159265359
#define PI_2 6.2831

vec3 colorPalatte(float angle, float value)
{
	float theta = mod(3.0 + ((3.0 * angle) / PI) + 1.5, 6.0);
	vec3 result = vec3(0.0);
	result = clamp(abs(mod(theta + vec3(0.0, 4.0, 2.0), 6.0) - 3.0) - 1.0, 0.0, 1.0);
	result = mix(vec3(1.0), result, value);
	return result;	
}

void main()
{
    vec2 p = (v_vTexcoord - 0.5) * 2.0;
    float dis = length(p);
    float angle = atan(p.x, p.y);
    vec4 col = vec4(colorPalatte(angle, dis), 1.0);
	col.a = 1.0 - smoothstep(0.98, 1.0, abs(dis));
	
    gl_FragColor = vec4(col);
}
