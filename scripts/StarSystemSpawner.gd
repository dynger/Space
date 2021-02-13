extends Node

func _input(event):
	if event.is_pressed():
		var def = generate_starsystem()
		var builder = StarSystemBuilder.new()
		var root = get_tree().get_root()
		var star_system = builder.build_star_system(root, def)
		get_tree().set_current_scene(star_system)

		# remove this node after switching to star system
		queue_free()

func generate_starsystem():
	var generator = StarSystemGenerator.new()
	return generator.generate_star_system()
