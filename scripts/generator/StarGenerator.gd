class_name StarGenerator

enum DeviationPick {INDIVIDUAL, GENERAL, NONE}

# used only if deviation pick is set to individual
# replace values with desired deviations
var deviation = {
	StarParameters.StarClass.O : {
		scale                  = 0,
		rotation_speed         = 0,
		energy                 = 0,
		color                  = Color.white,
	},

	StarParameters.StarClass.B : {
		scale                  = 0,
		rotation_speed         = 0,
		energy                 = 0,
		color                  = Color.white,
	},

	StarParameters.StarClass.A : {
		scale                  = 0,
		rotation_speed         = 0,
		energy                 = 0,
		color                  = Color.white,
	},

	StarParameters.StarClass.F : {
		scale                  = 0,
		rotation_speed         = 0,
		energy                 = 0,
		color                  = Color.white,
	},

	StarParameters.StarClass.G : {
		scale                  = 0,
		rotation_speed         = 0,
		energy                 = 0,
		color                  = Color.white,
	},

	StarParameters.StarClass.K : {
		scale                  = 0,
		rotation_speed         = 0,
		energy                 = 0,
		color                  = Color.white,
	},

	StarParameters.StarClass.M : {
		scale                  = 0,
		rotation_speed         = 0,
		energy                 = 0,
		color                  = Color.white,
	},
}

var general_deviation = 0.05
var deviation_pick : int = DeviationPick.GENERAL
var rng : RandomNumberGenerator

func _init(_rng):
	self.rng = _rng

func generate_star(star_class : int) -> StarDef:
	var result = StarDef.new()
	result.star_class = star_class
	if deviation_pick == DeviationPick.NONE:
		result.parameters = StarParameters.average[star_class].duplicate()
	else:
		result.parameters = random_parameters(star_class)
	return result

func random_parameters(star_class : int) -> Dictionary:
	var result = {}

	for key in StarParameters.average[star_class].keys():
		var average = StarParameters.average[star_class][key]
		var rng_offset
		if deviation_pick == DeviationPick.INDIVIDUAL:
			if deviation.has(star_class) and deviation[star_class].has(key):
				rng_offset = deviation[star_class][key]
			else:
				result[key] = average
				continue
		elif deviation_pick == DeviationPick.GENERAL:
			rng_offset = average * general_deviation
		else:
			return StarParameters.average[star_class].duplicate()
		var minimum = average - rng_offset
		var maximum = average + rng_offset
		var value
		if average is float:
			value = rng.randf_range(minimum, maximum)
		elif average is Color:
			value = random_color(minimum, maximum)
		else:
			# extend as needed
			push_error("unsupported type")
		result[key] = value

	return result

#func random_vec3(minimum: Vector3, maximum: Vector3) -> Vector3:
#	var x = rng.randf_range(minimum.x, maximum.x)
#	var y = rng.randf_range(minimum.y, maximum.y)
#	var z = rng.randf_range(minimum.z, maximum.z)
#	return Vector3(x,y,z)

func random_color(minimum: Color, maximum: Color) -> Color:
	var r = clamp(rng.randf_range(minimum.r, maximum.r), 0.0, 1.0)
	var g = clamp(rng.randf_range(minimum.g, maximum.g), 0.0, 1.0)
	var b = clamp(rng.randf_range(minimum.b, maximum.b), 0.0, 1.0)
	return Color(r,g,b)

func generate_random_star() -> StarDef:
	var star_class = random_star_class()
	return generate_star(star_class)

func random_star_class() -> int:
	var cumulative_intervals = _cumulative_distribution()
	var random_number = rng.randf()
	for i in range(cumulative_intervals.size()):
		if cumulative_intervals[i] >= random_number:
			return i
	# should never get here
	return StarParameters.StarClass.G

func _cumulative_distribution() -> Array:
	var result = []
	var n_classes = StarParameters.star_distribution.size()
	result.resize(n_classes)
	# always set the last entry to 1 to erase any floating point inaccuracy
	result[n_classes - 1] = 1.0
	for star_class in range(n_classes - 1):
		var previous_distribution = 0
		if star_class > 0:
			previous_distribution = result[star_class - 1]
		result[star_class] = StarParameters.star_distribution[star_class] + previous_distribution
	return result
