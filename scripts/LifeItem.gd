extends "res://scripts/Item.gd"


# Declare member variables here. Examples:

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func pick_up():
	.pick_up()
	global.lives += 1
	get_node("../Lives").redraw()

func _on_Area2D_body_entered(body):
	if body == player:
		pick_up()
		$Area2D/CollisionShape2D.set_deferred("disabled",true)
		hide()
		yield(get_tree().create_timer(1), "timeout")
		queue_free()
