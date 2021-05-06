extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", self, "_button_pressed")

func _button_pressed():
	print("Hello world!")
	global.lives = 3
	global.current_level = 1
	global.num_baddies = 0
	global.is_variant = true
	get_tree().change_scene("res://levels/level_" + str(global.current_level) + ".tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
