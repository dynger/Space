extends Spatial

var _n_vertecies := 50
var orbit_shader = preload("res://shaders/orbit.shader")
#var orbit_shader = preload("res://shaders/outline.shader")

func _ready():
	var satellites = get_tree().get_nodes_in_group(Groups.SATELLITES)
	for satellite in satellites:
		create_orbit(satellite)

func create_orbit(satellite: Satellite):
	var center = satellite.get_parent().transform.origin
	var radius = satellite.get_orbit_radius()
#	var scale = satellite.get_visual_scale().length() / 2
	print("creating orbit for satellite '%s'. center: %s, radius: %s" % [satellite.name, center, radius])
	var mouse_over_mesh = create_orbit_mesh_instance(Vector3.UP, radius)
	satellite.add_child(mouse_over_mesh)

func create_orbit_mesh_instance(up: Vector3, radius: float) -> MeshInstance:
#	var vertices : PoolVector3Array = create_orbit_outline_vertices(radius, half_scale)
	var vertices : PoolVector3Array = create_orbit_vertices(radius)
	var mesh_instance = MeshInstance.new()
#	mesh_instance.set_layer_mask_bit(2, true)
	mesh_instance.mesh = create_orbit_mesh(vertices)
	mesh_instance.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_OFF
#	mesh_instance.material_override = ShaderMaterial.new()
#	mesh_instance.material_override.shader = orbit_shader
	var material = ShaderMaterial.new()
	mesh_instance.mesh.surface_set_material(0, material)
	material.shader = orbit_shader

	rotate_orbit(mesh_instance, up)
	return mesh_instance

func create_orbit_vertices(radius: float) -> PoolVector3Array:
	var vertices = PoolVector3Array()
	var step = PI / _n_vertecies
	var theta = 0
	while theta < TAU:
		vertices.append(Vector3(
			radius * cos(theta),
			radius * sin(theta), 0))
		theta += step
	return vertices

#func create_orbit_outline_vertices(radius: float, outer_radius_half_width) -> PoolVector3Array:
#	var vertices = PoolVector3Array()
#	var step = PI / _n_vertecies
#	var theta = 0
#
#	while theta < TAU:
#		vertices.append(Vector3(
#			(radius-outer_radius_half_width) * cos(theta),
#			(radius-outer_radius_half_width) * sin(theta), 0))
#
#		vertices.append(Vector3(
#			(radius+outer_radius_half_width) * cos(theta),
#			(radius+outer_radius_half_width) * sin(theta), 0))
#
#		vertices.append(Vector3(
#			(radius-outer_radius_half_width) * cos(theta + step),
#			(radius-outer_radius_half_width) * sin(theta + step), 0))
#
#		vertices.append(Vector3(
#			(radius+outer_radius_half_width) * cos(theta),
#			(radius+outer_radius_half_width) * sin(theta), 0))
#
#		vertices.append(Vector3(
#			(radius-outer_radius_half_width) * cos(theta + step),
#			(radius-outer_radius_half_width) * sin(theta + step), 0))
#
#		vertices.append(Vector3(
#			(radius+outer_radius_half_width) * cos(theta + step),
#			(radius+outer_radius_half_width) * sin(theta + step), 0))
#
#		theta += step
#	return vertices

func create_orbit_mesh(vertices: PoolVector3Array) -> Mesh:
	var mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINE_LOOP, arrays)
#	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	return mesh#.generate_triangle_mesh()

func rotate_orbit(orbit: MeshInstance, up: Vector3) -> void:
	var forward = Vector3.FORWARD
	var axis = forward.cross(up)
	axis = axis.normalized()
	var cosa = forward.dot(up)
	var angle = acos(cosa)
	orbit.transform = orbit.transform.rotated(axis, angle)
