extends Camera
class_name BlenderCamera

const pi_half: float = deg2rad(90)
var rotation_speed: float = 1.0
var move_xy_speed: float = 1.0
var move_z_speed: float = 1.0
#var pivot_point: Vector3 = Vector3.ZERO
var envelope : Envelope
var motion_action: Vector3 = Vector3.ZERO
var rotation_action: Vector3 = Vector3.ZERO

signal camera_transformed

#func set_pivot_point(pivot_point: Vector3) -> void:
#	self.pivot_point = pivot_point

func add_rotation_action(action: Vector3) -> void:
	rotation_action = action


func move_xy(translate_xy_action) -> void:
	motion_action.x = translate_xy_action.x
	motion_action.y = translate_xy_action.y
#	motion_action = motion_action.normalized()

func move_z(forward: bool) -> void:
	if forward:
		motion_action.z -= move_z_speed
	else:
		motion_action.z += move_z_speed

func _process(delta: float) -> void:
	if motion_action != Vector3.ZERO:
#		print("have translation: %s" % motion_action)
		_proces_translation(delta)
		emit_signal("camera_transformed")
	if rotation_action != Vector3.ZERO:
#		print("have rotation: %s" % rotation_action)
		_process_rotation(delta)
		emit_signal("camera_transformed")

func _proces_translation(delta: float) -> void:
	translate(motion_action * delta)

func _process_rotation(delta: float) -> void:
	rotation.y -= rotation_action.y * rotation_speed * delta
	# Vertical mouse look, clamped to -90..90 degrees
	rotation.x = clamp(rotation.x - rotation_action.x * rotation_speed * delta, -pi_half, pi_half)
#	emit_signal("camera_transformed")
