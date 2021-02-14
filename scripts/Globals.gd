extends Node

# Here's how the visual layers work.
#
# Lighting the scene:

# Stars emit light and they are the only light source in a star system.
# Since they must not reflect their own light, stars have their own layer
# which is not affected by light.
# They constist of a mesh with a light emitting material and an omni light.
# Both the omni light and the mesh instance are on the STAR layer.
# The cull mask for the omni light is on the NON_STAR layer.
# Non-star objects so far consist only of satellites, ie planets and moons.
# They reflect the star's light.
# Orbits have their own layer which is not affected by light.

# Outlines:

# Outlines are drawn by a shader on a seperate viewport. The viewport's camera
# sees only the outline layer. Objects are added to and removed from the
# outline layer on demand (eg. hover mouse over object).

const VisualLayer = { STAR     = 0, # emits light, not affected by light itself
											NON_STAR = 1, # receives light
											ORBIT    = 5, # does not receive light
											OUTLINE  = 10 # does not receive light, used on demand.
										}
