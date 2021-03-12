extends Camera

class_name CameraMovement

export var rotation_speed = 0.002
export var move_speed = 100.0
export var zoom_speed = 0.1
onready var initial_rotation := rotation.y
var mouse_middle_pressed = false
var shift_pressed = false
var motion = Vector3()
var zoom_count = ZoomCount.new()
const pi_half = deg2rad(90)
var movement_envelope = Envelope.new()

signal camera_transformed

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
			else:
				# Horizontal mouse look
				rotation.y -= event.relative.x * rotation_speed
				# Vertical mouse look, clamped to -90..90 degrees
				rotation.x = clamp(rotation.x - event.relative.y * rotation_speed, -pi_half, pi_half)
				emit_signal("camera_transformed")

	else:
		clear_motion_xy()

	if not shift_pressed:
		clear_motion_xy()

func clear_motion_xy() -> void:
	motion.x = 0
	motion.y = 0

func _process(delta) -> void:
	if motion != Vector3.ZERO:
		var speed_factor = movement_envelope.get_level(delta)
		translate(motion * move_speed * speed_factor)
		emit_signal("camera_transformed")


	if motion.z != 0:
		var limit_reached = zoom_count.zooming(delta)
		if limit_reached:
			motion.z = 0
			zoom_count.reset_count()

class ZoomCount:
	var count = 0
	var limit = 10

	func zooming(_delta) -> bool:
		count += 1
		return count >= limit

	func reset_count():
		count = 0

#class Smoother:
#	enum State {IDLE, ATTACK, SUSTAIN, DECAY}
#	var state = State.IDLE
#	var level = 0.0
#	var wave_length = 60 # in number of frames
#	var attack = 1/wave_length
#	var sustain = 5.0
#	var decay = 1.0
#	var speed = 0.0
#	var gain = 1.0
#
#	func start_move() -> void:
#		state = State.ATTACK
#
#	func get_move_speed(delta) -> float:
#		if state == State.ATTACK:
#			increase_level()
#		elif state == State.DECAY:
#			decrease_level()
#		return speed
#
#	func is_idle():
#		return state == State.IDLE
#
#	func increase_level() -> void:
#			if level < 1.0:
#				level += attack
#			if level >= 1.0:
#				level = 1.0
#				state = State.SUSTAIN
#
#	func increase_speed() -> void:
#		if speed != sustain:
#			var new_speed = sin(incline) * gain
#			if new_speed > sustain:
#				speed = sustain
#			else:
#				speed = new_speed
#
#	func stop_move(delta) -> void:
#		state = State.DECAY

#	func stop_move(delta):
#		if incline > 0:
#			if incline - delta < 0:
#				incline = 0.0
#			else:
#				incline -= delta
#		return -sin(incline) * decay



















