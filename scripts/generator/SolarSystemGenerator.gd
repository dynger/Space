extends Node

var planet_materials = ["material path"]

#func _ready():
#	load("material path")

func generate_planet() -> CelestialBodyDef:
	var planet = CelestialBodyDef.new()
	planet.orbit_radius = rng_radius()

	planet.material = rng_planet_material()
	planet.scale = rng_scale()
	return planet

func rng_planet_material():
	# pick random index from planet_material
	# retrun range 0 bis planet_materials.size-1
	return null
