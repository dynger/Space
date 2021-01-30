extends Spatial

class_name CelestialBody

func _ready():
	add_to_group(Groups.CELESTIAL_BODIES)



func _on_Area_input_event(_camera, event, _click_position, _click_normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			print("left click %s at screen global %s and screen local %s" % [name, event.global_position, event.position])


