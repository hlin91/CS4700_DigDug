extends "res://scripts/RedBaddie.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	original_walk_speed = 90
	walk_speed = original_walk_speed
	sprite_path = "./BlueBaddieSprite"
	sprite = get_node(sprite_path)
	base_score = 400


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
