extends KinematicBody2D

# Declare member variables here. Examples:
export (float) var walk_speed = 0.5
var velocity = Vector2(walk_speed, 0)
var collision_info
var sprite
var player
var inflation = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = get_node("./RedBaddieSprite")
	player = get_node("./GridKinematics2d")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
<<<<<<< HEAD
	if (inflation == 0):
		collision_info = move_and_collide(velocity)
		if (collision_info != null):
			velocity = velocity * -1
			print(velocity)
			sprite.play_walking_animation(velocity.normalized())
			self.queue_free()
		#At some point, every so often, get the player's position
		#Locate a cell somewhat near the player that has been dug out.
		#Move to that cell, using some custom movement function that halts _process
	
func move_to_cell(cell_position):
	pass
	#


func _on_RedBaddieHurtArea_area_shape_entered(area_id, area, area_shape, self_shape):
	pass # Replace with function body.
	#case 1: it's the player
		#do nothing
	#case 2: it's a projectile
		#increment inflation
		#check if inflation meets threshold for death
			#self.queue_free()

=======
	collision_info = move_and_collide(velocity)
	if (collision_info != null):
		velocity = velocity * -1
		#print(velocity)
		sprite.play_walking_animation(velocity.normalized())
		
>>>>>>> 82c5153b4c0791127f5bcc9a4773dc83cb55d3d4
