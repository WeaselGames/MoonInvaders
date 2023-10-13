shader_type canvas_item;

uniform vec4 color_from;
uniform vec4 color_to;
uniform vec4 color_bg;

uniform float progress;

void fragment() {
	vec2 base_uv = UV;
	
	float percentage = smoothstep(0.0+progress,0.0 +progress + 0.01,UV.x);
	COLOR.rgb = mix(mix(color_from.rgb, color_to.rgb, progress), color_bg.rgb, percentage);
}