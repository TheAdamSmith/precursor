shader_type canvas_item;

uniform float red_adder = 0.0;
uniform float green_adder = 0.0;
uniform float blue_adder = 0.0;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	COLOR.r += red_adder;
	COLOR.g += green_adder;
	COLOR.b += blue_adder;
}
