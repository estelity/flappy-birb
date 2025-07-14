extends Node

@export var pipe_scene : PackedScene

var game_running : bool
var game_over : bool
var scroll
var score
var highscore = 0
const SCROLL_SPEED : int = 4
var screen_size : Vector2i
var ground_height : int
var pipes : Array
const PIPE_DELAY : int = 100
const PIPE_RANGE : int = 200

func _ready():
	screen_size = get_window().size
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()
	new_game()

func new_game():
	#reset variables
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	$ScoreLabel.text = "SCORE: " + str(score) + "\n" + "HIGHSCORE: " + str(highscore)
	generate_pipes()
	$birb.reset()
	$GameOver.hide()
	pipes.clear()
	get_tree().call_group("pipes", "queue_free")

func _input(event):
	if game_over == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				if game_running == false:
					start_game()
				else:
					if $birb.flying:
						$birb.flap()
						check_top()

func start_game():
	game_running = true
	$birb.flying = true
	$birb.flap()
	$pipetimer.start()
	
func _process(delta):
	if game_running:
		scroll += SCROLL_SPEED
		# reset scroll
		if scroll >= screen_size.x:
			scroll = 0
		# move ground node
		$Ground.position.x = -scroll
		for pipe in pipes:
			pipe.position.x -= SCROLL_SPEED

func _on_pipetimer_timeout() -> void:
	generate_pipes()
	
func generate_pipes():
	var pipe = pipe_scene.instantiate()
	pipe.position.x = screen_size.x + PIPE_DELAY
	pipe.position.y = (screen_size.y + ground_height)/2 + randi_range(-PIPE_RANGE, PIPE_RANGE)
	pipe.hit.connect(bird_hit)
	pipe.scored.connect(scored)
	add_child(pipe)
	pipes.append(pipe)
	
func scored():
	score += 1
	if score > highscore:
		highscore = score
	$ScoreLabel.text = "SCORE: " + str(score) + "\n" + "HIGHSCORE: " + str(highscore)

func check_top():
	if $birb.position.y < 0:
		$birb.falling = true
		stop_game()

func stop_game():
	$pipetimer.stop()
	$GameOver.show()
	$birb.flying = false
	game_running = false
	game_over = true

func bird_hit():
	$birb.falling = true
	stop_game()

func _on_ground_hit():
	$birb.falling = false
	stop_game()

func _on_game_over_restart():
	new_game()
