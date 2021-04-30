extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	self.rect_position = Vector2(768,192)
	self.rect_size = Vector2(120,60)
	text = "Lives: " + str(global.lives)

func decrement_lives():
	global.lives -= 1
	text = "Lives: " + str(global.lives)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
