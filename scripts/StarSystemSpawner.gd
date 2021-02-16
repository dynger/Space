extends Node

func _input(event):
	if event.is_pressed():
#		var def = generate_star_system()
		var def = generate_star_system_with_class(StarParameters.StarClass.O)
		var builder = StarSystemBuilder.new()
		var root = get_tree().get_root()
		var star_system = builder.build_star_system(root, def)
		get_tree().set_current_scene(star_system)

		# remove this node after switching to star system
		queue_free()

func generate_star_system() -> StarSystemDef:
	var generator = _create_generator()
	return generator.generate_star_system()

func generate_star_system_with_class(star_class: int) -> StarSystemDef:
	var generator = _create_generator()
	return generator.generate_star_system_with_class(star_class)

func _create_generator():
	var rng = RandomNumberGenerator.new()
	rng.seed = 11
	var generator = StarSystemGenerator.new()
	generator.rng = rng
	generator.star_generator = StarGenerator.new(rng)
	return generator
