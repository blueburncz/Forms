varying vec2 v_vTexCoord;

uniform vec4 u_vTopLeft;
uniform vec4 u_vTopRight;
uniform vec4 u_vBottomRight;
uniform vec4 u_vBottomLeft;

void main()
{
	gl_FragColor.rgba = mix(
		mix(u_vTopLeft, u_vTopRight, v_vTexCoord.x),
		mix(u_vBottomLeft, u_vBottomRight, v_vTexCoord.x),
		v_vTexCoord.y);
}