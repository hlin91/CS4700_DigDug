extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (float) var walk_speed = 1
var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("move_right"):
		velocity = Vector2(1, 0)
	elif Input.is_action_pressed("move_left"):
		velocity = Vector2(-1, 0)
	elif Input.is_action_pressed("move_down"):
		velocity = Vector2(0, 1)
	elif Input.is_action_pressed("move_up"):
		velocity = Vector2(0, -1)
	velocity = velocity.normalized() * walk_speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	get_input()
	move_and_slide(velocity)
	# Get specific tile player has collided with
#	if collision and collision.collider is TileMap:
#		var tile_pos = collision.collider.world_to_map(position)
#		tile_pos -= collision.normal
#		var tile_id = collision.collider.get_cellv(tile_pos)
#		collision.collider.set_cellv(tile_pos, -1) # Delete the tile
#		# For testing
#		print(tile_id)
	for i in range(get_slide_count()):
		var collision = get_slide_collision(i)
		if collision.collider is TileMap:
			var tile_pos = collision.collider.world_to_map(collision.position - collision.normal)
			collision.collider.set_cellv(tile_pos, -1)
			print(tile_pos)
