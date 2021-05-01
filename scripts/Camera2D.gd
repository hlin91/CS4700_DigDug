extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func small_shake():
	$ScreenShake.start(0.1, 15, 2, 0)

func med_shake():
	$ScreenShake.start(0.1, 15, 4, 0)
