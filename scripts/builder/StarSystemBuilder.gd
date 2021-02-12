class_name StarSystemBuilder

var satellite_packed = load("res://scenes/Satellite.tscn")
var star_packed = load("res://scenes/Star.tscn")

func buildScene(root: Node, def: StarSystemDef):
	var star_node = Spatial.new()
	root.add_child(star_node)
	var star_def = def.get_star()
	var star_body = build_star(star_def)
	star_node.add_child(star_body)
	var orbit_builder = OrbitBuilder.new()

	for planet_def in def.planets:
		var planet_node = Spatial.new()
		star_body.add_child(planet_node)
		var planet_body = build_body(planet_def)
		planet_node.add_child(planet_body)
		planet_body.transform.origin = Vector3(planet_def.orbit_radius, 0, 0)
		orbit_builder.create_orbit(planet_body)

		for moon_def in planet_def.body_children:
			var moon_node = Spatial.new()
			planet_body.add_child(moon_node)
			var moon_body = build_body(moon_def)
			moon_node.add_child(moon_body)
			moon_body.transform.origin = Vector3(moon_def.orbit_radius, 0, 0)
			orbit_builder.create_orbit(moon_body)

func build_star(def: CelestialBodyDef) -> CelestialBody:
	var node = star_packed.instance()
	initialize_body(node, def)
	return node

func build_body(def: CelestialBodyDef) -> Satellite:
	var node = satellite_packed.instance()
	initialize_body(node, def)
	return node

func initialize_body(node: CelestialBody, def: CelestialBodyDef) -> void:
	var mesh = node.get_node("MeshInstance")
	mesh.scale = def.scale
	node.definition = def
	connect_signals(node)

func connect_signals(node):
	var collision_area = node.get_node("MeshInstance/Area")
	collision_area.connect("input_event", node, "_on_Area_input_event")
	collision_area.connect("mouse_entered", node, "_on_Area_mouse_entered")
	collision_area.connect("mouse_exited", node, "_on_Area_mouse_exited")
