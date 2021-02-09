class_name OrbitMeshBuilder

var _n_vertecies := 50
var vertices : Array
var outline_vertices : Array

func build_orbit(radius : float, n_vertecies: int = 32):
	_n_vertecies = n_vertecies
	vertices = []
	vertices.resize(n_vertecies)
	outline_vertices = []


