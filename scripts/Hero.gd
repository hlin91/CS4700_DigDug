extends AnimatedSprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("move_right"):
		set_flip_h(false)
		rotation_degrees = 0
	elif Input.is_action_pressed("move_left"):
		set_flip_h(true)
		rotation_degrees = 0
	elif Input.is_action_pressed("move_down"):
		if flip_h:
			rotation_degrees = -90
		else:
			rotation_degrees = 90
	elif Input.is_action_pressed("move_up"):
		if flip_h:
			rotation_degrees = 90
		else:
			rotation_degrees = -90
