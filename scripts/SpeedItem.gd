extends "res://scripts/Item.gd"

export var increased_speed = 115

func pick_up():
	.pick_up()

	player.walk_speed = increased_speed


func _on_SpeedArea_body_entered(body):
	if body == player:
		pick_up()
		$Area2D/CollisionShape2D.set_deferred("disabled",true)
		hide()
		yield(get_tree().create_timer(1), "timeout")
		queue_free()
