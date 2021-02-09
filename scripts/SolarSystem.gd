extends Spatial

var _n_vertecies := 50
var orbit_shader = preload("res://shaders/orbit.shader")

func _ready():
	var satellites = get_tree().get_nodes_in_group(Groups.SATELLITES)
	for satellite in satellites:
		create_orbit(satellite)

func create_orbit(satellite: Satellite) -> void:
	var center = satellite.get_parent().transform.origin
	var radius = satellite.get_orbit_radius()
	print("creating orbit for satellite '%s'. center: %s, radius: %s" % [satellite.name, center, radius])
	var mesh = create_orbit_mesh_instance(satellite, Vector3.UP, radius)
	satellite.add_child(mesh)

func create_orbit_mesh_instance(satellite: Satellite, up: Vector3, radius: float) -> MeshInstance:
	var vertices : Array = create_orbit_vertices(radius)
	var vertex_pool : PoolVector3Array = PoolVector3Array(vertices)
	var mesh_instance = MeshInstance.new()
	mesh_instance.name = "orbit"
	mesh_instance.mesh = create_mesh(vertex_pool, Mesh.PRIMITIVE_LINE_LOOP)
	mesh_instance.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_OFF
	var material = ShaderMaterial.new()
	mesh_instance.mesh.surface_set_material(0, material)
	material.shader = orbit_shader

	var half_scale = satellite.get_visual_scale().length() / 2
	var collision_area = create_orbit_outline_area(radius, half_scale)
	mesh_instance.add_child(collision_area)

	collision_area.connect("input_event", satellite, "_on_Area_input_event")
	collision_area.connect("mouse_entered", satellite, "_on_Area_mouse_entered")
	collision_area.connect("mouse_exited", satellite, "_on_Area_mouse_exited")

	rotate_orbit(mesh_instance, up)
	return mesh_instance

func create_orbit_vertices(radius: float) -> Array:
	var vertices = []
	var step = TAU / _n_vertecies
	var theta = 0
	while theta < TAU:
		vertices.append(Vector3(radius * cos(theta), radius * sin(theta), 0))
		theta += step
	return vertices

func create_orbit_outline_area(radius: float, line_width) -> Area:
	var vertices = create_orbit_outline_vertices(radius, line_width)
	var mesh = create_mesh(vertices, Mesh.PRIMITIVE_TRIANGLES)

	var mesh_instance = MeshInstance.new()
	mesh_instance.name = "orbit_outline"
	mesh_instance.mesh = mesh
	mesh_instance.create_trimesh_collision()

	var collision_shape = mesh_instance.get_child(0).get_child(0)
	collision_shape.get_parent().remove_child(collision_shape)

	mesh_instance.free()
	var area = Area.new()
	area.add_child(collision_shape)
	return area

func create_orbit_outline_vertices(radius: float, line_width) -> PoolVector3Array:
	var vertices = PoolVector3Array()
	var step = TAU / _n_vertecies
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

#func create_orbit_outline(radius: float, line_width) -> PoolVector3Array:
#	var vertices = PoolVector2Array()
#	var step = TAU / _n_vertecies
#	var theta = 0
#
#	var inner = radius - line_width
#	var outer = radius + line_width
#
#	while theta < TAU:
#		var next_step = theta + step
#
#		var a = Vector2(inner * cos(theta), inner * sin(theta))
#		var b = Vector2(outer * cos(theta), outer * sin(theta))
#		var c = Vector2(inner * cos(next_step), inner * sin(next_step))
#		var d = Vector2(outer * cos(next_step), outer * sin(next_step))
#
#		vertices.append(a)
#		vertices.append(b)
#		vertices.append(c)
#		vertices.append(c)
#		vertices.append(b)
#		vertices.append(d)
#
#		theta += step
#	return vertices

func create_mesh(vertices: PoolVector3Array, type) -> Mesh:
	var mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	mesh.add_surface_from_arrays(type, arrays)
	return mesh

func rotate_orbit(orbit: MeshInstance, up: Vector3) -> void:
	var forward = Vector3.FORWARD
	var axis = forward.cross(up)
	axis = axis.normalized()
	var cosa = forward.dot(up)
	var angle = acos(cosa)
	orbit.transform = orbit.transform.rotated(axis, angle)
