extends CheckButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _toggled(button_pressed):
	print("button toggled!")
	if global.music == true:
		global.music = false
		get_node("../MainScreenBGM").stop()
	else:
		global.music = true
		get_node("../MainScreenBGM").play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
