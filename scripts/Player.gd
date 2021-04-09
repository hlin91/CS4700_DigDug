extends "res://scripts/GridKinematics.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var game_over = false
	
#func get_input():
#	velocity = Vector2()
#	if Input.is_action_pressed("move_right"):
#		velocity = Vector2(1, 0)
#	elif Input.is_action_pressed("move_left"):
#		velocity = Vector2(-1, 0)
#	elif Input.is_action_pressed("move_down"):
#		velocity = Vector2(0, 1)
#	elif Input.is_action_pressed("move_up"):
#		velocity = Vector2(0, -1)
#	velocity = velocity.normalized() * walk_speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if (!game_over):
		get_input()
		update_position()

func _on_PlayerHurtbox_area_entered(area):
	game_over = true
