extends "res://scripts/GridKinematics.gd"

# Declare member variables here. Examples:
export var player_path = "../Player"
export var pump_reset_time = 1.5
export var pumps_to_kill = 8
export var enemy_layer = 2
var collision_info
var player
var inflation = 0
var time_to_ghost_threshold = 300
var time_to_hunt_threshold = 5
var current_time = 0
var time_until_reset_pump = pump_reset_time
var is_hunting = false
var is_ghosting = false
var is_walking = false
var pump_scale_factor = 1.5 / pumps_to_kill
var moveable_neighbors

# Called when the node enters the scene tree for the first time.
func _ready():
	#set_collision_layer(enemy_layer)
	sprite_path = "./RedBaddieSprite"
	move_tiles = get_node(move_tiles_path)
	sprite = get_node(sprite_path)
	player = get_node("../Player")
	walk_speed = 50
	velocity = Vector2(walk_speed,0)
	print(player)
	in_transit = false
	sprite.set_to_walk()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if inflation > 0: # Currently getting pumped
		time_until_reset_pump -= delta
		if time_until_reset_pump <= 0:
			time_until_reset_pump = pump_reset_time
			print("Decreasing inflation")
			inflation -= 1
			sprite.change_scale(Vector2(-1*pump_scale_factor,-1*pump_scale_factor))
			if inflation == 0: # Get out of pumping state
				print("No longer pumped.")
				get_node(player_path).pumping = null


func normal_motion(delta):
	collision_info = move_and_collide(velocity*delta)
	if (collision_info != null):
		velocity = velocity * -1
		sprite.play_walking_animation(velocity.normalized())
	current_time += delta
	if (current_time >= time_to_hunt_threshold):
		current_time = 0
		is_hunting = true

func hunt_motion():
	if (!in_transit):
		moveable_neighbors = move_tiles.get_moveable_neighbors(current_cell)
	collision_info = move_and_collide(velocity*0)
	if (moveable_neighbors.size() == 0 or collision_info): #case for being trapped in cell at hunt time
		#And also for being snagged on a dirttile
		move_to_cell(player.current_cell)
		disable_collision_and_ghost()
	else:
		if (!in_transit):
			move_to_cell(move_tiles.get_nearest_neighbor(moveable_neighbors,player.current_cell))
		update_position()

func ghost_motion():
	update_position()
	if (arrived()):
		enable_collision_and_unghost()
		velocity = Vector2(1,0)
	
func _physics_process(delta):
	if (inflation == 0):
		if (is_ghosting == false): #case for standard "non-ghosting" movement
			if (is_hunting):
				hunt_motion()
			else: #using grid movement to go to player tile.
				normal_motion(delta)
		else: #case for being a ghost in transit
			ghost_motion()

func disable_collision_and_ghost():
	print("going ghost!")
	is_ghosting = true
	$TerrainCollision.set_deferred("disabled",true)
	$RedBaddieHurtArea/RedBaddieHurtAreaShape.set_deferred("disabled",true)
	sprite.set_to_ghost()

func enable_collision_and_unghost():
	print("ungoing ghost!")
	is_ghosting = false
	$TerrainCollision.set_deferred("disabled",false)
	$RedBaddieHurtArea/RedBaddieHurtAreaShape.set_deferred("disabled",false)
	sprite.set_to_walk()
	
func move_and_process(velocity):
	move_and_slide(velocity)
	
func hit():
	get_node(player_path).pumping = self
	pump()

func pump():
	inflation += 1
	print("I'm getting pumped!")
	print("Current inflation: " + str(inflation))
	sprite.change_scale(Vector2(pump_scale_factor,pump_scale_factor))
	if inflation >= pumps_to_kill:
		print("I am dead.")
		queue_free()
	
func _on_RedBaddieHurtArea_area_shape_entered(area_id, area, area_shape, self_shape):
	pass # Replace with function body.
	#case 1: it's the player
		#do nothing
	#case 2: it's a projectile
		#increment inflation
		#check if inflation meets threshold for death
			#self.queue_free()
		
