extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var pump_threshold = .5
var pump_value = 0
var make_bigger = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pump_value += delta
	if (pump_value >= pump_threshold):
		pump_value = 0
		if make_bigger:
			scale = Vector2(1.4,1.4)
			make_bigger = false
		else:
			scale = Vector2(1,1)
			make_bigger = true
