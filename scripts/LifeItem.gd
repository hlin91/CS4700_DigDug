extends "res://scripts/Item.gd"


# Declare member variables here. Examples:

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func pick_up():
	global.lives += 1



func _on_Area2D_body_entered(body):
	if body == player:
		pick_up()
		queue_free()
