extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var int_score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	int_score = global.score
	text = "Score: " + str(int_score)
	self.rect_position = Vector2(768,64)
	self.rect_size = Vector2(120,60)

func update_score(additional_score):
	int_score += additional_score
	if global.high_score < int_score:
		global.high_score = int_score
	global.score = int_score
	text = "Score: " + str(int_score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
