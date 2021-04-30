extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	text = "High Score: " + str(global.high_score) 
	self.rect_position = Vector2(768,64)
	self.rect_size = Vector2(120,60)

func update_score():
	text = "High Score: " + str(global.high_score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
