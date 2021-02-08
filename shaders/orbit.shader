shader_type spatial;
render_mode unshaded, cull_disabled;

void vertex() {
	POINT_SIZE = 100.0;
}

void fragment() {
    ALBEDO = vec3(1.0, 1.0, 1.0);
}