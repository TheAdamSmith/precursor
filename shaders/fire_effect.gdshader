
shader_type canvas_item;

uniform vec4 brighter_color : source_color = vec4(1.0, 0.8, 0.0, 0.0);
uniform float brighter_period_sec = 1.0;
uniform float brighter_intensity = 0.5;

uniform vec4 middle_color : source_color  = vec4(1.0, 0.56, 0.0, 0.0);
uniform float middle_period_sec = 1.0;
uniform float middle_intensity = 0.5;

uniform vec4 darker_color : source_color  = vec4(0.64, 0.2, 0.05, 0.0);
uniform float darker_period_sec = 1.0;
uniform float darker_intensity = 0.5;

void fragment()
{
	COLOR = texture(TEXTURE, UV);
	COLOR.rgb += brighter_intensity * brighter_color.rgb * abs(sin(TAU * (TIME / brighter_period_sec)));
	COLOR.rgb += middle_intensity * middle_color.rgb * abs(sin(TAU * (TIME / middle_period_sec)));
	COLOR.rgb += darker_intensity * darker_color.rgb * abs(sin(TAU * (TIME / darker_period_sec)));
}