extends CelestialBody

class_name Satellite

var orbit_radius : float
#var orbit_angle : float
onready var canvas_layer

func _ready():
	var mesh = get_node("MeshInstance")
	orbit_radius = transform.origin.length()
	print("%s orbit radius around %s: %s" % [name, get_parent().name, orbit_radius])
	canvas_layer = get_node("/root/StarSystem/CanvasLayer")

func draw_orbit():
	pass


