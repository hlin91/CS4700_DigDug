extends AnimatedSprite

# Declare member variables here. Examples:
enum DIR {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

func set_to_walk():
	play("walking")

func set_to_ghost():
	play("ghosting")
	
func set_to_pumped():
	play("hurting")

func change_scale(scale_vector):
	scale += scale_vector

func play_walking_animation(direction):
	match direction:
		Vector2(-1,0):
			set_flip_h(false)
			rotation_degrees = 0
		Vector2(1,0):
			set_flip_h(true)
			rotation_degrees = 0
		Vector2(0,-1):
			if flip_h:
				rotation_degrees = -90
			else:
				rotation_degrees = 90
		Vector2(0,1):
			if flip_h:
				rotation_degrees = 90
			else:
				rotation_degrees = -90


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
