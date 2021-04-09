extends KinematicBody2D

# Declare member variables here. Examples:
export (float) var walk_speed = 1
var velocity = Vector2(walk_speed, 0)
var collision_info
var sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = get_node("./RedBaddieSprite")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	collision_info = move_and_collide(velocity)
	if (collision_info != null):
		velocity = velocity * -1
		#print(velocity)
		sprite.play_walking_animation(velocity.normalized())
		
