extends Node

func _input(_event):
#	get_tree().change_scene("res://scenes/EmptyStarSystem.tscn")
	if Input.is_action_just_pressed("ui_accept"):
		get_node("InstructionsLabel").visible = false
		var def = generate_starsystem()
		var scene = load("res://scenes/EmptyStarSystem.tscn").instance()
		var builder = StarSystemBuilder.new()
		builder.buildScene(scene, def)
		get_tree().root.add_child(scene)
		get_tree().current_scene = scene

func generate_starsystem():
	var generator = StarSystemGenerator.new()
	return generator.generate_star_system()

