extends "res://scripts/Item.gd"

export var increased_speed = 115

func pick_up():
	player.walk_speed = increased_speed


func _on_SpeedArea_body_entered(body):
	if body == player:
		pick_up()
		queue_free()
