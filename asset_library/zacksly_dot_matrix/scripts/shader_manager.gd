extends ColorRect

onready var viewport = get_viewport()
var minimum_size = Vector2(1920, 1080)

func _ready():
	viewport.connect("size_changed", self, "window_resize")
	pass # Replace with function body.

func window_resize():
	print("resize")
	var current_size = OS.get_window_size()
#	var scale_factor = minimum_size.y	/current_size.y
#	var scale_factor = minimum_size.y	/current_size.y
	
	var ratio = current_size.x / current_size.y
	print (ratio)
	material.set_shader_param("AspectRatio", ratio)
