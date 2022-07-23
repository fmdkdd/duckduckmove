extends Polygon2D

export var scroll_speed = 0.5

func _physics_process(_delta):
	texture_offset.y += scroll_speed
	
