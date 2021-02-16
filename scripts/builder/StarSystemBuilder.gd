class_name StarSystemBuilder

var satellite_packed = load("res://scenes/Satellite.tscn")
var star_packed = load("res://scenes/Star.tscn")
var star_system_packed = load("res://scenes/EmptyStarSystem.tscn")

func build_star_system(root: Viewport, def: StarSystemDef) -> Spatial:
	var star_system = star_system_packed.instance()
	root.add_child(star_system)
	var star_node = Spatial.new()
	star_system.add_child(star_node)
	var star_body = star_packed.instance()
	star_node.add_child(star_body)
	var star_def = def.get_star()
	star_body.initialize_from_stats(star_def)
	var orbit_builder = OrbitBuilder.new()

	for planet_def in def.planets:
		var planet_node = Spatial.new()
		star_body.add_child(planet_node)
		var planet_body = satellite_packed.instance()
		planet_node.add_child(planet_body)
		initialize_satellite(planet_body, planet_def)
		planet_body.transform.origin = Vector3(planet_def.orbit_radius, 0, 0)
		orbit_builder.create_orbit(planet_body)

		for moon_def in planet_def.body_children:
			var moon_node = Spatial.new()
			planet_body.add_child(moon_node)
			var moon_body = satellite_packed.instance()
			moon_node.add_child(moon_body)
			initialize_satellite(moon_body, moon_def)
			moon_body.transform.origin = Vector3(moon_def.orbit_radius, 0, 0)
			orbit_builder.create_orbit(moon_body)

	return star_system

func initialize_satellite(node: Satellite, def: CelestialBodyDef) -> void:
	var mesh = node.get_node("MeshInstance")
	mesh.scale = def.scale
	node.definition = def
	node.rotation_speed = def.self_rotation
	connect_signals(node)

func connect_signals(node: CelestialBody):
	var collision_area = node.get_node("MeshInstance/Area")
	collision_area.connect("input_event", node, "_on_Area_input_event")
	collision_area.connect("mouse_entered", node, "_on_Area_mouse_entered")
	collision_area.connect("mouse_exited", node, "_on_Area_mouse_exited")
