extends Camera

export var rotation_speed = 0.002
export var move_speed = 100.0
export var zoom_speed = 0.1
onready var initial_rotation := rotation.y
var mouse_middle_pressed = false
var shift_pressed = false
var motion = Vector3()
var zoom_count = ZoomCount.new()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var button_index = event.get_button_index()
		if button_index == BUTTON_MIDDLE:
			mouse_middle_pressed = event.is_pressed()
		elif button_index == BUTTON_WHEEL_UP:
			motion.z -= zoom_speed
		elif button_index == BUTTON_WHEEL_DOWN:
			motion.z += zoom_speed

	if event is InputEventKey and event.get_scancode() == KEY_SHIFT:
		shift_pressed = event.is_pressed()

	if mouse_middle_pressed:
		if event is InputEventMouseMotion:
			if shift_pressed:
				motion.x = -event.relative.x
				motion.y = event.relative.y
				motion = motion.normalized()
				print("apply motion: %s" % motion)
			else:
				# Horizontal mouse look
				rotation.y -= event.relative.x * rotation_speed
				# Vertical mouse look, clamped to -90..90 degrees
				rotation.x = clamp(rotation.x - event.relative.y * rotation_speed, deg2rad(-90), deg2rad(90))
	else:
		clear_motion_xy()

	if not shift_pressed:
		clear_motion_xy()

func clear_motion_xy() -> void:
	motion.x = 0
	motion.y = 0

func _process(delta) -> void:
	translate(motion * move_speed * delta)

	if motion.z != 0:
		var limit_reached = zoom_count.zooming(delta)
		if limit_reached:
			motion.z = 0
			zoom_count.reset_count()

class ZoomCount:
	var count = 0
	var limit = 0.3

	func zooming(delta) -> bool:
		count += delta
		print("zoom count: %s" % count)
		return count >= limit

	func reset_count():
		count = 0
