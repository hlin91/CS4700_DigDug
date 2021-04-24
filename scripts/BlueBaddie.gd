extends "res://scripts/RedBaddie.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	walk_speed = 50
	sprite_path = "./BlueBaddieSprite"
	sprite = get_node(sprite_path)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
