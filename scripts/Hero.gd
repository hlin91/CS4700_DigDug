extends AnimatedSprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var moving = false
var facing # Direction the sprite is currently facing
var digging = false
enum DIR {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

# Called when the node enters the scene tree for the first time.
func _ready():
	play("hero_idl")

func play_walking_animation(direction):
	match direction:
		DIR.RIGHT:
			set_flip_v(false)
			facing = DIR.RIGHT
		DIR.LEFT:
			set_flip_v(true)
			facing = DIR.LEFT
		DIR.DOWN:
			facing = DIR.DOWN
		DIR.UP:
			facing = DIR.UP
	play("hero_walking")

func clear_animation():
	play("hero_idl")

func play_pumping_animation():
	if (animation != "hero_pumping"):
		play("hero_pumping")
	
func play_shooting_animation():
	play("hero_shoot")

func play_dig_animation(direction):
	match direction:
		DIR.RIGHT:
			set_flip_v(false)
			facing = DIR.RIGHT
		DIR.LEFT:
			set_flip_v(true)
			facing = DIR.LEFT
		DIR.DOWN:
			facing = DIR.DOWN
		DIR.UP:
			facing = DIR.UP
	play("hero_dig")

func move_animation(direction):
	if !moving:
		moving = true
		if digging:
			play_dig_animation(direction)
		else:
			play_walking_animation(direction)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	var local_moving = false
#	if Input.is_action_pressed("move_right"):
#		set_flip_h(false)
#		rotation_degrees = 0
#		local_moving = true
#	elif Input.is_action_pressed("move_left"):
#		set_flip_h(true)
#		rotation_degrees = 0
#		local_moving = true
#	elif Input.is_action_pressed("move_down"):
#		if flip_h:
#			rotation_degrees = -90
#		else:
#			rotation_degrees = 90
#		local_moving = true
#	elif Input.is_action_pressed("move_up"):
#		if flip_h:
#			rotation_degrees = 90
#		else:
#			rotation_degrees = -90
#		local_moving = true
#	if local_moving != moving:
#		if local_moving:
#			play("hero_walking")
#		else:
#			play("hero_idl")
#	moving = local_moving
