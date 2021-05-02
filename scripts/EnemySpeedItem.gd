extends "res://scripts/Item.gd"


# Declare member variables here. Examples:
export var increased_speed = 100


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func pick_up():
	var baddies = get_tree().get_nodes_in_group("baddies")
	for baddie in baddies:
		baddie.walk_speed = increased_speed


func _on_Area2D_body_entered(body):
	if body == player:
		pick_up()
		queue_free()
