extends Node

#var spawned = false
#signal toggle_pause

func _input(event):
#	if not spawned:
	if event.is_pressed():
		get_node("InstructionsLabel").set_visible(false)
		var def = generate_starsystem()
		var scene = load("res://scenes/EmptyStarSystem.tscn").instance()
		var builder = StarSystemBuilder.new()
		builder.buildScene(scene, def)
		get_tree().root.add_child(scene)
		get_tree().current_scene = scene

#			spawned = true
		# remove this node after switching to star system
		queue_free()
#	else:
#		if event is InputEventKey and event.is_pressed() and event.scancode == KEY_SPACE:
#			var satellites = get_tree().get_nodes_in_group(Groups.SATELLITES)


func generate_starsystem():
	var generator = StarSystemGenerator.new()
	return generator.generate_star_system()

