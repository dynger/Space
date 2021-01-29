extends Node2D

var camera: CameraMovement

func _ready():
	camera = get_node("/root/StarSystem/Camera")
	camera.connect("camera_transformed", self, "_on_camera_transformed")

func _draw():
	draw_circular_orbit(Vector3(), Vector3.UP, 30.0)

func _on_camera_transformed():
	update()

#func draw_viewport_circle():
#	var viewport_rect = get_viewport_rect()
#	var center = viewport_rect.size / 2.0
#	var radius = 100.0
#	var step = PI / 90.0
#	var theta = 0
#	var points = []
#
#	while theta <= 2 * PI:
#		var x = center.x + radius * cos(theta)
#		var y = center.y + radius * sin(theta)
#		points.append(Vector2(x, y))
#		theta += step
#
#	draw_polyline(PoolVector2Array(points), Color.white)

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
#		var translated_point = point.translated
		var point2d = camera.unproject_position(rotated_point)
		points2d.append(point2d)
		theta += step

	draw_polyline(PoolVector2Array(points2d), Color.white)

#func create_circular_orbit_points(radius: float) -> Array:
#	var result = []
#	var step = PI / 50.0
#	var theta = 0
#	var center = Vector3()
#
#	while theta <= 2 * PI:
#		var x = center.x + radius * cos(theta)
#		var y = center.y + radius * sin(theta)
#		result.append(Vector3(x, y, 0))
#		theta += step
#
#	return result
