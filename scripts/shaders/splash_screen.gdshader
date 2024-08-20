shader_type canvas_item;
uniform float angle = 0.0;
void fragment() {
	float offset = PI;
	float x_cord = (0.5-UV.x)*2.0;
	float y_cord = (0.5-UV.y)*2.0;
	if (atan(-x_cord,y_cord) > angle-offset) {
		COLOR.a = 0.0;
	}
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
