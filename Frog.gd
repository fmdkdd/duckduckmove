extends Area2D

export var move_speed = 4

var acceleration = Vector2.ZERO
var can_jump = true
var floor_y

func _ready():
	floor_y = position.y

func _physics_process(_delta):
	var move_x = 0
	if Input.is_action_pressed("move_left"):
		move_x -= move_speed
	if Input.is_action_pressed("move_right"):
		move_x += move_speed
	if Input.is_action_pressed("jump") and can_jump:
		can_jump = false	
		acceleration.y -= 13
		
	position.x = clamp(position.x + move_x, 10, 790)
	position.y += acceleration.y
	
	if position.y < floor_y:
		acceleration.y += 0.9
		#acceleration.y = clamp(acceleration.y, -30, 30)
		$Sprite.playing = false
	else:
		acceleration.y = 0
		can_jump = true
		$Sprite.playing = true
