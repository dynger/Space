extends CelestialBody

class_name Star

onready var light = get_node("OmniLight")
var star_class : int

func get_star_class() -> int:
	return star_class

func set_star_class(value) -> void:
	star_class = value

func get_engergy() -> float:
	return light.light_energy

func set_energy(value) -> void:
	light.light_energy = value
	var material = mesh_instance.get_surface_material(0)
	if material and material is SpatialMaterial:
		material.set_emission_energy(value)

func get_color() -> Color:
	return light.light_color

func set_color(value) -> void:
	light.light_color = value
	# TODO sort this out...
	# there's a total of 3 materials:
	# 1) the mesh material (mesh_instance.mesh.surface_get_material(int))
	# 2) the mesh instance material (mesh_instance.get_surface_material(int)) used here
	# 3) material override in GeometryInstance
	# what's the difference between them?
	var material = mesh_instance.get_surface_material(0)
	if material and material is SpatialMaterial:
		material.emission = value
		material.albedo_color = value


func initialize_from_stats(star_def: StarDef) -> void:
	set_star_class(star_def.star_class)
	set_scale(Vector3.ONE * star_def.parameters["scale"])
	set_rotation_speed(star_def.parameters["rotation_speed"])
	set_energy(star_def.parameters["energy"])
	set_color(star_def.parameters["color"])
