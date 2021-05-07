extends "res://scripts/Item.gd"

export var slow_factor = .35

func pick_up():
	.pick_up()
	var baddies = get_tree().get_nodes_in_group("baddies")
	for baddie in baddies:
		baddie.walk_speed *= slow_factor

func _on_SlowEnemiesArea_body_entered(body):
	if body == player:
		pick_up()
		$Area2D/CollisionShape2D.set_deferred("disabled",true)
		hide()
		yield(get_tree().create_timer(1), "timeout")
		queue_free()
