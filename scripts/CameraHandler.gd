extends Spatial
class_name CameraHandler

var transform_modifier_pressed = false
var move_xy_modifier_pressed = false
onready var _camera : BlenderCamera = get_node("Camera")
var rotation_rate : float = 1.0

func _input(event: InputEvent) -> void:
	_update_modifiers()
	_update_camera(event)

func _update_modifiers():
	if Input.is_action_just_pressed("camera_transform"):
		transform_modifier_pressed = true
	if Input.is_action_just_released("camera_transform"):
		transform_modifier_pressed = false
	if Input.is_action_just_pressed("camera_translate_xy"):
		move_xy_modifier_pressed = true
	if Input.is_action_just_released("camera_translate_xy"):
		move_xy_modifier_pressed = false

func _update_camera(event: InputEvent):
	print("transform modifier pressed: %s" % transform_modifier_pressed)
	print("translate xy modifier pressed: %s" % move_xy_modifier_pressed)
	var translation_action = Vector3.ZERO
	var rotation_action = Vector3.ZERO
	if transform_modifier_pressed and event is InputEventMouseMotion:
		if move_xy_modifier_pressed:
			translation_action.x = event.relative.x
			translation_action.y = event.relative.y
			_camera.move_xy(translation_action)
		else:
			_camera.move_xy(translation_action)
			if event.relative.y > 0.0:
				rotation_action.x += rotation_rate
			elif event.relative.y < 0.0:
				rotation_action.x -= rotation_rate

			if event.relative.x > 0.0:
				rotation_action.y += rotation_rate
			elif event.relative.x < 0.0:
				rotation_action.y -= rotation_rate
		_camera.add_rotation_action(rotation_action)
	else:
		rotation_action = Vector3.ZERO
		_camera.add_rotation_action(rotation_action)
		_camera.move_xy(translation_action)




#	if event is InputEventMouseButton:
#		var button_index = event.get_button_index()
#		if button_index == BUTTON_MIDDLE:
#			translate_modifier_pressed = event.is_pressed()
#		elif button_index == BUTTON_WHEEL_UP:
#			motion.z -= zoom_speed
#		elif button_index == BUTTON_WHEEL_DOWN:
#			motion.z += zoom_speed

#	if event is InputEventKey and event.get_scancode() == KEY_SHIFT:
#		shift_pressed = event.is_pressed()
#
#	if translate_modifier_pressed:
#		if event is InputEventMouseMotion:
#			if shift_pressed:
#				motion.x = -event.relative.x
#				motion.y = event.relative.y
#				motion = motion.normalized()
#			else:
#				# Horizontal mouse look
#				rotation.y -= event.relative.x * rotation_speed
#				# Vertical mouse look, clamped to -90..90 degrees
#				rotation.x = clamp(rotation.x - event.relative.y * rotation_speed, -pi_half, pi_half)
#				emit_signal("camera_transformed")

#	else:
#		clear_motion_xy()

#	if not move_xy_modifier_pressed:
#		clear_motion_xy()
