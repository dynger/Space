class_name StarSystemDef

# Atm only single stars are supported.
# Multi star systems probably need adjustments in scene tree.
var sun : CelestialBodyDef setget set_star, get_star
#var suns = []
var planets = []
#var moons = []

func set_star(value: CelestialBodyDef):
	sun = value

func get_star():
	return sun
