shader_type canvas_item;
render_mode world_vertex_coords;
uniform sampler2D image_texture: repeat_enable, filter_nearest;
uniform float image_scale = 1.0;
uniform vec2 time_scale = vec2(0.0, 0.0);
uniform vec2 parallax_scale = vec2(0.0, 0.0);
uniform vec2 cam_pos;
varying vec2 world_position;

void vertex() {
	world_position = VERTEX + vec2(cam_pos.x * parallax_scale.x, cam_pos.y * parallax_scale.y);
}

void fragment() {
	vec4 data = texture(image_texture, vec2(world_position.x, world_position.y)/image_scale + TIME * time_scale);
	COLOR.rgb = data.rgb;
	COLOR.a = data.a;
}

