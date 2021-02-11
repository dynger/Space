class_name StarSystemBuilder

var celestial_body_packed = load("res://scenes/CelestialBody.tscn")

func buildScene(root: Node, def: StarSystemDef):
	var star_node = CelestialBody.new()
	root.add_child(star_node)
	var star_def = def.get_star()
	var star_body = build_body(star_def)
	star_node.add_child(star_body)
	var orbit_builder = OrbitBuilder.new()

	for planet_def in def.planets:
		var planet_node = Satellite.new()
		star_body.add_child(planet_node)
		var planet_body = build_body(planet_def)
		planet_node.add_child(planet_body)
		planet_body.transform.origin = Vector3(planet_def.orbit_radius, 0, 0)
		orbit_builder.create_orbit(planet_node)

		for moon_def in planet_def.body_children:
			var moon_node = Satellite.new()
			planet_body.add_child(moon_node)
			var moon_body = build_body(moon_def)
			moon_node.add_child(moon_body)
			moon_body.transform.origin = Vector3(moon_def.orbit_radius, 0, 0)
			orbit_builder.create_orbit(moon_node)

func build_body(def: CelestialBodyDef) -> Spatial:
	var node = celestial_body_packed.instance()
	node.set_name("Body")
	var mesh = node.get_node("MeshInstance")
	mesh.scale = def.scale
	return node

#func build_planet(def: CelestialBodyDef) -> Spatial:
#	var node = celestial_body_packed.instance()
#	var mesh = node.get_node("MeshInstance")
#	mesh.scale = def.scale
