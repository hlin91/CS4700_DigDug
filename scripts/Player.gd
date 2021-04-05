extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (float) var walk_speed = 1
var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("move_right"):
		velocity = Vector2(1, 0)
	if Input.is_action_pressed("move_left"):
		velocity = Vector2(-1, 0)
	if Input.is_action_pressed("move_down"):
		velocity = Vector2(0, 1)
	if Input.is_action_pressed("move_up"):
		velocity = Vector2(0, -1)
	velocity = velocity.normalized() * walk_speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
