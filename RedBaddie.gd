extends KinematicBody2D


# Declare member variables here. Examples:
export (float) var walk_speed = 1
	var velocity = Vector2(1, 0)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func process_collision(collision_normal):
	#Here, use the collision normal to determine new cardinal velocity.
	#Hit the ceiling, set velocity downward, and so on.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_slide(velocity)
	for i in range(get_slide_count()):
		var collision = get_slide_collision(0)
		if collision.collider is TileMap:
			process_collision(collision.normal)
