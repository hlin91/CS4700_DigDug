extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var int_score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	text = "Score: 0"
	print(self)

func update_score(additional_score):
	int_score += additional_score
	text = "Score: " + str(int_score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
