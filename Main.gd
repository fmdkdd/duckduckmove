extends Node

export(PackedScene) var rock_scene
export var rock_speed = 1.0

var is_game_over
var difficulty
var rock_spawn_number
var ground_scroll_speed
var score

func _ready():
	restart()

func _process(delta):
	if is_game_over and Input.is_action_just_released("jump"):
		restart()
		
	if not is_game_over:
		score += delta * pow(2, difficulty)
		#print(score)
		
func restart():
	score = 0.0
	difficulty = 0
	rock_spawn_number = 3
	$Ground.scroll_speed = 1.5
	rock_speed = 3.05
	$Duck.speed_scale = 0.8
	$Duck.scale = Vector2(4,4)
	$Frog/Sprite.speed_scale = 3
	
	is_game_over = false
	$HUD/Message.hide()
	$HUD/Score.hide()
	$Frog.show()
	$Frog.set_physics_process(true)
	get_tree().call_group("rocks", "queue_free")
	$DifficultyTimer.start()
	$Music.play()
	
func game_over():
	$Frog.hide()
	$Frog.set_physics_process(false)
	$HUD/Message.show()
	$HUD/Score.text = "Score: %s" % floor(score)
	$HUD/Score.show()
	is_game_over = true
	$DifficultyTimer.stop()

func spawn_rock():
	var x = rand_range(50, 750)
	var direction = (randi() % 2) * 2 - 1
	var n = rock_spawn_number
	
	for i in range(n):
		var rock = rock_scene.instance()
		rock.position = Vector2(x + i * direction * 70, 630 + i * 30)
		rock.speed = rock_speed
		add_child(rock)
		
func raise_difficulty():
	difficulty += 1
	rock_spawn_number = clamp(rock_spawn_number + 1, 0, 10)
	$Ground.scroll_speed *= 1.2
	rock_speed *= 1.2
	$Duck.speed_scale *= 1.1
	if $Duck.scale.x < 14:
		$Duck.scale *= 1.1
	$Frog/Sprite.speed_scale *= 1.05
	get_tree().call_group("rocks", "increase_speed")
	
func _on_RockSpawnTimer_timeout():
	spawn_rock()
	
func _on_Frog_area_shape_entered(_area_rid, _area, _area_shape_index, _local_shape_index):
	game_over()
	
func _on_DifficultyTimer_timeout():
	raise_difficulty()
