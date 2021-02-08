extends Camera


var game_camera: Camera

func _ready():
	# TODO the exact same code is run in (deprecate) draw orbits on screen solution
	game_camera = get_node("/root/StarSystem/Camera")
	transform = game_camera.transform
	var error = game_camera.connect("camera_transformed", self, "_on_camera_transformed")
	if error != OK:
		print("Error when connecting signal! Error code: %s" % error)
	
func _on_camera_transformed():
	transform = game_camera.transform
