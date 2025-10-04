shader_type canvas_item;

uniform vec4 flash_color: source_color;
uniform bool flashing;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	if (flashing){
		COLOR = vec4(flash_color.x, flash_color.y, flash_color.z, texture_color.a);
	} else{
		COLOR = texture_color;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
