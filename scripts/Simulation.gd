extends Spatial
class_name Simulation

var is_simulation_running = true

signal set_simulation_running

func _input(_event):
	if Input.is_action_just_pressed("toggle_pause"):
		is_simulation_running = not is_simulation_running
		emit_signal("set_simulation_running", is_simulation_running)
