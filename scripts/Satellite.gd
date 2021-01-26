extends CelestialBody

class_name Satellite


func _ready():
	create_orbit()

func create_orbit():
	var orbit_radius_world = get_orbit_radius_world()
	print("orbit radius world: %s" % orbit_radius_world)
#	var orbit_sprite = get_parent().find_node("OrbitSprite")
#	var pixel_size = orbit_sprite.get_pixel_size()
#	var planet_mesh = find_node("MeshInstance")
#	var planet_position = planet_mesh.transform.origin
	var orbit_radius_pixel = get_orbit_radius_pixel(orbit_radius_world)
	print("orbit radius pixel: %s" % orbit_radius_pixel)

#	var orbit_image = create_orbit_image(orbit_radius_pixel)
#	var orbit_sprite = get_parent().find_node("OrbitSprite2")
#	var texture = ImageTexture.new()
#	texture.create_from_image(orbit_image)
#	orbit_sprite.texture = texture

#	var image = Image.new()
#	image.create()
#	image.fill(Color.black)
#	orbit_sprite.texture.create_from_image(image)

func get_orbit_radius_world():
	var planet_mesh = find_node("MeshInstance")
	var planet_position = planet_mesh.transform.origin
	return planet_position.distance_to(self.transform.origin)

func get_orbit_radius_pixel(orbit_radius_world):
	var orbit_sprite = get_parent().find_node("OrbitSprite2")
	var pixel_size = orbit_sprite.get_pixel_size()
	return orbit_radius_world / pixel_size

func create_orbit_image(orbit_radius_pixel):
	var image = Image.new()
	var width = orbit_radius_pixel * 2
	image.create(width, width, false, Image.FORMAT_RGBA8)
	image.fill(Color.black)
	return image
