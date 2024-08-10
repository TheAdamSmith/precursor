shader_type canvas_item;

uniform float red = 0.0;
uniform float green = 0.0;
uniform float blue = 0.0;
uniform float max_intensity = 1.0;

uniform float period_sec = 1.0;
uniform float num_cycles = 1.0;

uniform float start_time = 0.0;

void fragment() {
	float time_elapsed_sec = TIME - start_time;
	COLOR = texture(TEXTURE, UV);
	if (start_time != 0.0 && time_elapsed_sec < period_sec * num_cycles) {
		float intensity = max_intensity * abs(sin(TAU * (time_elapsed_sec / period_sec)));
		COLOR.r += red * intensity;
		COLOR.b += blue * intensity;
		COLOR.g += green * intensity;
	}
}
