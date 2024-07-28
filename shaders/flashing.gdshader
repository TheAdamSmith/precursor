shader_type canvas_item;

uniform float red = 0.0;
uniform float green = 0.0;
uniform float blue = 0.0;
uniform float max_intensity = 1.0;

uniform float cycle_duration_sec = 1.0;
uniform float num_cycles = 1.0;

uniform float start_time = 0.0;

void fragment() {
	float time_elapsed = TIME - start_time;
	COLOR = texture(TEXTURE, UV);
	if (time_elapsed < cycle_duration_sec * num_cycles) {
		float intensity = max_intensity * abs(sin(time_elapsed / (2.0 * cycle_duration_sec)));
		COLOR.r += red * intensity;
		COLOR.b += blue * intensity;
		COLOR.g += green * intensity;
	}
}
