class_name StarSystemGenerator

# ATTENTION: Be VERY careful with n_planet_max and n_moon_max!
# I set n_moon_max to 100 and the engine got stuck creating the scene.
# After 20 minutes, I reset my PC because the whole OS had frozen.
# This might be because of the "big" number of game objects or because the
# distances were so big... probably because of the number of objects
const n_planet_min = 1
const n_planet_max = 15

const n_moon_min = 0
const n_moon_max = 4

const scale_star_min = 7.0
const scale_star_max = 12.0
const scale_planet_min = 1.0
const scale_planet_max = 2.0
const scale_moon_min = 0.1
const scale_moon_max = 0.2

const orbit_radius_factor_planet_min = 1.36
const orbit_radius_factor_planet_max = 3.34

var rng: RandomNumberGenerator

func _init(_seed = null):
	rng = RandomNumberGenerator.new()
	if _seed != null:
		rng.set_seed(_seed)

func generate_star_system() -> StarSystemDef :
	var result = StarSystemDef.new()
	var star = generate_star()
	result.set_star(star)

	var next_inner_orbit_planet = star.scale.x
	var n_planets = rng.randi_range(n_planet_min, n_planet_max)
	for _i in range(n_planets):
		var planet = generate_planet(next_inner_orbit_planet)
		result.planets.append(planet)
		next_inner_orbit_planet = planet.orbit_radius

		var next_inner_orbit_moon = planet.scale.x
		var n_moons = rng.randi_range(n_moon_min, n_moon_max)
		for _j in range(n_moons):
			var moon = generate_moon(next_inner_orbit_moon)
			planet.body_children.append(moon)
			next_inner_orbit_moon = moon.orbit_radius
#	for i in range(random_planet_number.randi_range(1,12)):
#		var planet = body_generator.generate_planet(last_radius)
#		var last_moon_radius = planet.scale.x
#		last_radius = planet.orbit_radius
#		star_system.planets.append(planet)
#		for u in range (random_planet_number.randi_range(1,12)):
#			var moon = body_generator.generate_planet(last_moon_radius)
#			last_moon_radius = moon.orbit_radius
#			moon.scale = planet.scale / 10
#			planet.body_children.append(moon)
	return result

func generate_star() -> CelestialBodyDef:
	var result = CelestialBodyDef.new()
	result.scale = Vector3.ONE * rng.randf_range(scale_star_min, scale_star_max)
	return result

func generate_planet(next_inner_orbit: float) -> CelestialBodyDef:
	var result = CelestialBodyDef.new()
	result.scale = Vector3.ONE * rng.randf_range(scale_planet_min, scale_planet_max)
	var rand_radius_factor = rng.randf_range(orbit_radius_factor_planet_min, orbit_radius_factor_planet_max)
	result.orbit_radius = next_inner_orbit * rand_radius_factor
	return result

func generate_moon(next_inner_orbit: float) -> CelestialBodyDef:
	var result = CelestialBodyDef.new()
	result.scale = Vector3.ONE * rng.randf_range(scale_moon_min, scale_moon_max)
	var rand_radius_factor = rng.randf_range(orbit_radius_factor_planet_min, orbit_radius_factor_planet_max)
	result.orbit_radius = next_inner_orbit * rand_radius_factor
	return result
