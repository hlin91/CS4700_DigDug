extends "res://scripts/GridKinematics.gd"

# Declare member variables here. Examples:
var collision_info
var player
var inflation = 0
var time_to_move = 3
var current_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_path = "./RedBaddieSprite"
	move_tiles = get_node(move_tiles_path)
	sprite = get_node(sprite_path)
	player = get_node("../Player")
	velocity = Vector2(1,0)
	print(player)
	in_transit = false
	walk_speed = 50

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if (in_transit == false):
		collision_info = move_and_collide(velocity)
		if (collision_info != null):
			velocity = velocity * -1
			print(velocity)
			sprite.play_walking_animation(velocity.normalized())
		current_time += delta
		if (current_time >= time_to_move):
			current_time = 0
			move_to_cell(player.current_cell)
			disable_collision_and_ghost()
			update_position()
	else:
		update_position()
		if (arrived()):
			enable_collision_and_unghost()
			velocity = Vector2(1,0)

func disable_collision_and_ghost():
	print("tried and true")
	$TerrainCollision.set_deferred("disabled",true)
	$RedBaddieHurtArea.set_deferred("disabled",true)
	sprite.play_ghosting_animation()

func enable_collision_and_unghost():
	$TerrainCollision.set_deferred("disabled",false)
	$RedBaddieHurtArea.set_deferred("disabled",false)
	sprite.play_monster_animation()
	
func move_and_process(velocity):
	move_and_slide(velocity)

func _on_RedBaddieHurtArea_area_shape_entered(area_id, area, area_shape, self_shape):
	pass # Replace with function body.
	#case 1: it's the player
		#do nothing
	#case 2: it's a projectile
		#increment inflation
		#check if inflation meets threshold for death
			#self.queue_free()
		
