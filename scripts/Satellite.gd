#tool
extends CelestialBody

class_name Satellite

export (float) var orbit_radius = 30.0 setget _init_orbit_radius, get_orbit_radius
export (Vector3) var orbit_angle = Vector3() setget _init_orbit_angle

func _ready():
	$MeshInstance.transform.origin = Vector3(orbit_radius, 0, 0)
	add_to_group(Groups.SATELLITES)

func _init_orbit_radius(value) -> void:
	orbit_radius = value

func _init_orbit_angle(value) -> void:
	orbit_angle = value

func get_orbit_radius() -> float:
	return orbit_radius

func _on_Area_mouse_entered():
	# dot notation calls super implementation
	._on_Area_mouse_entered()
	get_node("orbit").set_layer_mask_bit(2, true)

func _on_Area_mouse_exited():
	._on_Area_mouse_exited()
	get_node("orbit").set_layer_mask_bit(2, false)
