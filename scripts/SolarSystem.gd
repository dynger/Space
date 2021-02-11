extends Spatial

var _n_vertecies := 50
var orbit_shader = preload("res://shaders/orbit.shader")

func _ready():
	var builder = OrbitBuilder.new()
	var satellites = get_tree().get_nodes_in_group(Groups.SATELLITES)
	for satellite in satellites:
		builder.create_orbit(satellite)
