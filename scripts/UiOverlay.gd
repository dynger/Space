extends Node2D

var camera: CameraMovement
var orbiting = []

func _ready():
	camera = get_node("/root/StarSystem/Camera")
	var error = camera.connect("camera_transformed", self, "_on_camera_transformed")
	if error != OK:
		print("Error when connecting signal! Error code: %s" % error)

func collect_orbits():
	var star_system = get_node("/root/StarSystem")


func append_satellite(node):
	if node is CelestialBody:
		if node is Satellite:
			orbiting.append(node)


func _draw():
	var satellites = get_tree().get_nodes_in_group(Groups.SATELLITES)
	for satellite in satellites:
		var center = satellite.get_parent().transform.origin
		var radius = satellite.get_orbit_radius()
		draw_circular_orbit(center, Vector3.UP, radius)


func _on_camera_transformed():
	update()

func draw_circular_orbit(center: Vector3, up: Vector3, radius: float):
	var step = PI / 50.0
	var theta = 0
	var center_viewport = Vector3()

	var forward = Vector3.FORWARD
	var axis = forward.cross(up)
	axis = axis.normalized()
	var cosa = forward.dot(up)
	var angle = acos(cosa)

	var points2d = []

	while theta <= 2 * PI:
		var x = center_viewport.x + radius * cos(theta)
		var y = center_viewport.y + radius * sin(theta)
		var point = Vector3(x, y, 0)
		var rotated_point = point.rotated(axis, angle)
		var translated_point = rotated_point + center
		var point2d = camera.unproject_position(translated_point)
		points2d.append(point2d)
		theta += step

	draw_polyline(PoolVector2Array(points2d), Color.white)
