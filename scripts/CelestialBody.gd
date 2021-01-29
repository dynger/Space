extends Spatial

class_name CelestialBody

func _ready():
	pass



func _on_Area_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			print("left click %s at global %s and local %s" % [name, event.global_position, event.position])
