extends "res://scripts/GridKinematics.gd"

# Declare member variables here. Examples:
export var player_path = "../Player"
export var pump_reset_time = 1.5
export var pumps_to_kill = 8
export var enemy_layer = 2
var collision_info
var player
var inflation = 0
var time_to_move = 300
var current_time = 0
var time_until_reset_pump = pump_reset_time
var is_hunting = false
var pump_scale_factor = 1.5 / pumps_to_kill

# Called when the node enters the scene tree for the first time.
func _ready():
	set_collision_layer(enemy_layer)
	sprite_path = "./RedBaddieSprite"
	move_tiles = get_node(move_tiles_path)
	sprite = get_node(sprite_path)
	player = get_node("../Player")
	walk_speed = 0
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
			
func _physics_process(delta):
	if (inflation == 0):
		if (in_transit == false): #case for standard "non-ghosting" movement
			if (!is_hunting):
				collision_info = move_and_collide(velocity*delta)
				if (collision_info != null):
					velocity = velocity * -1
					sprite.play_walking_animation(velocity.normalized())
				current_time += delta
				if (current_time >= time_to_move):
					current_time = 0
					move_to_cell(player.current_cell)
					disable_collision_and_ghost()
					update_position()
			else: #using grid movement to go to player tile.
				pass
				#TODO: get the moveable tiles of the monster
				#NOTE: figure out some flag to not keep getting the moveable tiles
				#as it might be expensive and is definitely unnecessary
					#If there are no moveable tiles?
						#go ghost
					#else:
						#move to that tile by moving to cell
						#update position
		else: #case for being a ghost in transit
			update_position()
			if (arrived()):
				enable_collision_and_unghost()
				velocity = Vector2(1,0)

func disable_collision_and_ghost():
	print("tried and true")
	$TerrainCollision.set_deferred("disabled",true)
	$RedBaddieHurtArea.set_deferred("disabled",true)
	sprite.set_to_ghost()

func enable_collision_and_unghost():
	$TerrainCollision.set_deferred("disabled",false)
	$RedBaddieHurtArea.set_deferred("disabled",false)
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
		
