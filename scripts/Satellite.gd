extends CelestialBody
class_name Satellite

func _ready():
	add_to_group(Groups.SATELLITES)

func _physics_process(_delta):
	if is_simulation_running:
		transform = transform.rotated(Vector3.UP, definition.orbit_speed)

func _on_Area_mouse_entered():
	# dot notation calls super implementation
	._on_Area_mouse_entered()
	get_orbit().set_layer_mask_bit(Globals.VisualLayer.OUTLINE, true)

func _on_Area_mouse_exited():
	._on_Area_mouse_exited()
	get_orbit().set_layer_mask_bit(Globals.VisualLayer.OUTLINE, false)

func get_orbit():
	return get_node("../Orbit")
