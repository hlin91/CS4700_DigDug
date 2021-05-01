extends Particles2D


# Declare member variables here. Examples:
export var ON_DURATION = .5
var time_til_off

# Called when the node enters the scene tree for the first time.
func _ready():
	time_til_off = ON_DURATION

func _process(delta):
	# This emitter will only stay active for a set duration
	if is_emitting():
		time_til_off -= delta
		if time_til_off <= 0:
			set_emitting(false)

# Turn on the particle emitter
func turn_on():
	time_til_off = ON_DURATION
	set_emitting(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
