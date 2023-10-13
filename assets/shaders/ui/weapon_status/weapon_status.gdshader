shader_type canvas_item;

uniform float progress;

void fragment() {
	COLOR.rgba = vec4(COLOR.rgba - vec4(0.0, 0.0, 0.0, progress));
}
