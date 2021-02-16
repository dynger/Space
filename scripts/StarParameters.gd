extends Node

enum StarClass {O, B, A, F, G, K, M}

# these values must add up to 1
# source: https://en.wikipedia.org/wiki/Stellar_classification#Spectral_types
var star_distribution = {
	StarClass.O : 0.0003, # 0.00003% according to wiki. We set it a lot higher.
	StarClass.B : 0.00125,
	StarClass.A : 0.00625,
	StarClass.F : 0.0303 + 0.0069, # 0.0069 is the remainder to 1. we add it here for no particular reason
	StarClass.G : 0.075,
	StarClass.K : 0.12,
	StarClass.M : 0.76
}

var average = {
	StarClass.O : {
		scale                  = 15.0,
		rotation_speed         = 0.19,
		energy                 = 12.0,
		color                  = Color(0.608, 0.69, 1.0),
	},

	StarClass.B : {
		scale                  = 7.0,
		rotation_speed         = 0.2,
		energy                 = 9.0,
		color                  = Color(0.667, 0.749, 1.0),
	},

	StarClass.A : {
		scale                  = 2.5,
		rotation_speed         = 0.19,
		energy                 = 5.0,
		color                  = Color(0.792, 0.843, 1.0),
	},

	StarClass.F : {
		scale                  = 1.3,
		rotation_speed         = 0.095,
		energy                 = 3.0,
		color                  = Color(0.973, 0.969, 1.0),
	},

	StarClass.G : {
		scale                  = 1.1,
		rotation_speed         = 0.012,
		energy                 = 1.0,
		color                  = Color(1.0, 0.957, 0.918),
	},

	StarClass.K : {
		scale                  = 0.8,
		rotation_speed         = 0.0005,
		energy                 = 0.8,
		color                  = Color(1.0, 0.824, 0.631),
	},

	StarClass.M : {
		scale                  = 0.4,
		rotation_speed         = 0.001,
		energy                 = 0.2,
		color                  = Color(1.0, 0.8, 0.435),
	},
}

