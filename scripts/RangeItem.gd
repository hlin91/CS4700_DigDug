extends "res://scripts/Item.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var extend_value = 0.25

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func pick_up():
	player.bullet_extend += extend_value



func _on_Area2D_body_entered(body):
	if body == player:
		pick_up()
		queue_free()
