extends Spatial

func _ready():
	var builder = OrbitBuilder.new()
	var satellites = get_tree().get_nodes_in_group(Groups.SATELLITES)
	for satellite in satellites:
		builder.create_orbit(satellite)
