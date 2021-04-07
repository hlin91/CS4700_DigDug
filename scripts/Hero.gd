extends AnimatedSprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var moving = false
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
			set_flip_h(false)
			rotation_degrees = 0
		DIR.LEFT:
			set_flip_h(true)
			rotation_degrees = 0
		DIR.DOWN:
			if flip_h:
				rotation_degrees = -90
			else:
				rotation_degrees = 90
		DIR.UP:
			if flip_h:
				rotation_degrees = 90
			else:
				rotation_degrees = -90
	play("hero_walking")

func clear_animation():
	play("hero_idl")

func move_animation(direction):
	if !moving:
		moving = true
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
