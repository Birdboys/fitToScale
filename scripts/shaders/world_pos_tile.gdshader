shader_type canvas_item;
render_mode world_vertex_coords;
uniform sampler2D image_texture: repeat_enable, filter_nearest;
uniform float image_scale = 1.0;
uniform float time_scale = 0.0;
varying vec2 world_position;

void vertex() {
	world_position = VERTEX;
}

void fragment() {
	vec3 data = texture(image_texture, vec2(world_position.x, world_position.y)/image_scale + TIME * time_scale).rgb;
	COLOR.rgb = data;
}

