extends Spatial
class_name CelestialBody

var self_rotation : float = 0.01
onready var mesh_instance = get_node("Body/MeshInstance")

func _ready():
	add_to_group(Groups.CELESTIAL_BODIES)

func _physics_process(_delta):
	mesh_instance.transform = mesh_instance.transform.rotated(Vector3.UP, self_rotation)

func _on_Area_input_event(_camera, event, _click_position, _click_normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			print("left click %s at screen global %s and screen local %s" % [name, event.global_position, event.position])

func _on_Area_mouse_entered():
	get_mesh_instance().set_layer_mask_bit(2, true)

func _on_Area_mouse_exited():
	get_mesh_instance().set_layer_mask_bit(2, false)

func get_visual_scale():
	return get_mesh_instance().scale

func get_mesh_instance():
	return mesh_instance
