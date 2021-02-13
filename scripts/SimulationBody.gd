extends Spatial
class_name SimulationBody

var is_simulation_running

func _ready():
	add_to_group(Groups.SIMULATION_BODIES)
	var simulation = get_node("/root/StarSystem/Simulation")
	is_simulation_running = simulation.is_simulation_running
	simulation.connect("set_simulation_running", self, "_on_set_simulation_running")

func _on_set_simulation_running(value):
	is_simulation_running = value
