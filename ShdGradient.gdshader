shader_type spatial;

uniform vec3 color_bottom : source_color = vec3(0.0, 0.0, 0.0);
uniform vec3 color_top    : source_color = vec3(0.0, 0.0, 0.0);

uniform float min_height = 0.0;
uniform float max_height = 3.0;

varying vec3 world_position;

void vertex() {
	world_position = (MODEL_MATRIX * vec4(VERTEX.xy, 0.0, 1.0)).xyz;
}

void fragment() {
	float height = world_position.y - NODE_POSITION_WORLD.y;

	float factor = clamp((height - min_height) / (max_height - min_height), 0.0, 100.0);

	ALBEDO = mix(color_bottom.rgb, color_top.rgb, factor);
}