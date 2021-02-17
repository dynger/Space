class_name OrbitBuilder

var orbit_shader = preload("res://shaders/orbit.shader")

func create_orbit(satellite: Satellite) -> void:
	var radius = satellite.definition.orbit_radius
	# TODO fix for tilted orbit!
#	var up = Vector3(1, 2, 3).normalized()
	var up = Vector3.UP
	var mesh_instance = create_orbit_mesh_instance(satellite, up, radius)
	satellite.get_parent().add_child(mesh_instance)

func create_orbit_mesh_instance(satellite: Satellite, up: Vector3, radius: float) -> MeshInstance:
	var n_line_segments = radius * PI/2 + 32
	var vertices : Array = create_orbit_vertices(radius, n_line_segments)
	var mesh_instance = MeshInstance.new()
	mesh_instance.set_layer_mask(0) # clear the mask first because of default layer
	mesh_instance.set_layer_mask_bit(Globals.VisualLayer.ORBIT, true)
	mesh_instance.name = "Orbit"
	mesh_instance.mesh = create_mesh(vertices, Mesh.PRIMITIVE_LINE_LOOP)
	mesh_instance.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_OFF
	var material = ShaderMaterial.new()
	mesh_instance.mesh.surface_set_material(0, material)
	material.shader = orbit_shader

	var outline_width = 0.15
	var vertices_horizontal_outline = create_orbit_outline_vertices_horizontal(radius, n_line_segments, outline_width)
	var collision_area_horizontal = create_orbit_outline_area(vertices_horizontal_outline)
	mesh_instance.add_child(collision_area_horizontal)
	connect_signals(satellite, collision_area_horizontal)

	var vertices_vertical_outline = create_orbit_outline_vertices_vertical(radius, n_line_segments, outline_width)
	var collision_area_vertical = create_orbit_outline_area(vertices_vertical_outline)
	mesh_instance.add_child(collision_area_vertical)
	connect_signals(satellite, collision_area_vertical)

	rotate_orbit(mesh_instance, up)
	return mesh_instance

func create_orbit_vertices(radius: float, n_line_segments: int) -> Array:
	var vertices = []
	var step = TAU / n_line_segments
	var theta = 0
	while theta < TAU:
		vertices.append(Vector3(radius * cos(theta), radius * sin(theta), 0))
		theta += step
	return vertices

func create_mesh(vertices: Array, type) -> Mesh:
	var vertex_pool = PoolVector3Array(vertices)
	var mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertex_pool
	mesh.add_surface_from_arrays(type, arrays)
	return mesh

func create_orbit_outline_area(vertices) -> Area:
	var mesh = create_mesh(vertices, Mesh.PRIMITIVE_TRIANGLES)

	var mesh_instance = MeshInstance.new()
	mesh_instance.mesh = mesh
	mesh_instance.create_trimesh_collision()

	var collision_shape = mesh_instance.get_child(0).get_child(0)
	collision_shape.get_parent().remove_child(collision_shape)

	mesh_instance.queue_free()
	var area = Area.new()
	area.add_child(collision_shape)
	return area

func create_orbit_outline_vertices_horizontal(radius: float, n_line_segments, line_width) -> Array:
	var vertices = []
	var step = TAU / n_line_segments
	var theta = 0

	var inner = radius - line_width
	var outer = radius + line_width

	while theta < TAU:
		var next_step = theta + step

		var a = Vector3(inner * cos(theta), inner * sin(theta), 0)
		var b = Vector3(outer * cos(theta), outer * sin(theta), 0)
		var c = Vector3(inner * cos(next_step), inner * sin(next_step), 0)
		var d = Vector3(outer * cos(next_step), outer * sin(next_step), 0)

		vertices.append(a)
		vertices.append(b)
		vertices.append(c)
		vertices.append(c)
		vertices.append(b)
		vertices.append(d)

		theta += step
	return vertices

func create_orbit_outline_vertices_vertical(radius: float, n_line_segments, line_width) -> Array:
	var vertices = []
	var step = TAU / n_line_segments
	var theta = 0

	while theta < TAU:
		var next_step = theta + step

		var a = Vector3(radius * cos(theta), radius * sin(theta), -line_width)
		var b = Vector3(radius * cos(theta), radius * sin(theta), line_width)
		var c = Vector3(radius * cos(next_step), radius * sin(next_step), -line_width)
		var d = Vector3(radius * cos(next_step), radius * sin(next_step), line_width)

		vertices.append(a)
		vertices.append(b)
		vertices.append(c)
		vertices.append(c)
		vertices.append(b)
		vertices.append(d)

		theta += step
	return vertices

func connect_signals(satellite, collision_area):
	collision_area.connect("input_event", satellite, "_on_Area_input_event")
	collision_area.connect("mouse_entered", satellite, "_on_Area_mouse_entered")
	collision_area.connect("mouse_exited", satellite, "_on_Area_mouse_exited")

func rotate_orbit(orbit: MeshInstance, up: Vector3) -> void:
	var forward = Vector3.FORWARD
	var axis = forward.cross(up)
	axis = axis.normalized()
	var cosa = forward.dot(up)
	var angle = acos(cosa)
	orbit.transform = orbit.transform.rotated(axis, angle)
