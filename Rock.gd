extends Area2D

var speed = 0

func _physics_process(_delta):
	position.y -= speed
	
	if position.y < 273:
		queue_free()

func increase_speed():
	speed *= 1.2
