extends CelestialBody
class_name Satellite

onready var body = get_node("Body")
var orbit_radius = -1 setget , get_orbit_radius
#var orbit_angle = Vector3() setget _init_orbit_angle
var orbit_speed = 0.01

func _ready():
	add_to_group(Groups.SATELLITES)

func _physics_process(delta):
	body.transform = body.transform.rotated(Vector3.UP, orbit_speed)

func get_orbit_radius() -> float:
	if orbit_radius < 0:
		return get_node("Body").transform.origin.x
	else:
		return orbit_radius

func _on_Area_mouse_entered():
	# dot notation calls super implementation
	._on_Area_mouse_entered()
	get_orbit().set_layer_mask_bit(2, true)

func _on_Area_mouse_exited():
	._on_Area_mouse_exited()
	get_orbit().set_layer_mask_bit(2, false)

func get_orbit():
	return get_node("Orbit")
