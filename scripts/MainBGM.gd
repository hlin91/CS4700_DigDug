extends AudioStreamPlayer

var bgm = preload("res://assets/sounds/Electronic Fantasy.ogg")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	stream = bgm
	volume_db = -30
	if global.music:
		play() 

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
