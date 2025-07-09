extends CharacterBody2D

const GRAVITY : int = 1250
const MAX_VEL : int = 600
const FLAP_SPEED : int = -450
var flying : bool = false
var falling : bool = false
const START_POS = Vector2(100, 400)
# defines the start position?

# called when node enters the scene tree for the first time
func _ready():
	reset()
	# i think ready is a special func in godot, start of game

func reset():
	falling = false
	flying = false
	position = START_POS
	set_rotation(0)
	# resets any rotation that has been applied in the physics process

# called every frame; delta is the elapsed time between the frames
func _physics_process(delta):
	if flying or falling:
		velocity.y += GRAVITY * delta
		# teminal velocity
		if velocity.y > MAX_VEL:
			velocity.y = MAX_VEL
		if flying:
			set_rotation(deg_to_rad(velocity.y * 0.05))
			$AnimatedSprite2D
		elif falling:
			set_rotation(PI/2)
			$AnimatedSprite2D.stop()
		move_and_collide(velocity * delta)
	else:
		$AnimatedSprite2D.stop()
		
func flap():
	velocity.y = FLAP_SPEED
