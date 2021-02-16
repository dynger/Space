class_name StarSystemDef

# Atm only single stars are supported.
# Multi star systems probably need adjustments in scene tree.
var star : StarDef setget set_star, get_star
#var suns = []
var planets = []
#var moons = []

func set_star(value: StarDef):
	star = value

func get_star():
	return star
