extends SimulationBody
class_name CelestialBody

var definition : CelestialBodyDef
onready var mesh_instance = get_node("MeshInstance")

func _ready():
	add_to_group(Groups.CELESTIAL_BODIES)

func _physics_process(_delta):
	if is_simulation_running:
		mesh_instance.transform = mesh_instance.transform.rotated(Vector3.UP, definition.self_rotation)

func _on_Area_input_event(_camera, event, _click_position, _click_normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			print("left click %s at screen global %s and screen local %s" % [get_parent().name, event.global_position, event.position])

func _on_Area_mouse_entered():
	mesh_instance.set_layer_mask_bit(1, true)

func _on_Area_mouse_exited():
	mesh_instance.set_layer_mask_bit(1, false)
