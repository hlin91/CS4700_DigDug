extends "res://scripts/GridKinematics.gd"

# Declare member variables here. Examples:

signal baddie_died(base_score,current_cell)

export var player_path = "../Player"
export var score_path = "../Score"
export var sprite_path = ""
export var camera_path = "../Camera"
export var pump_reset_time = .5
export var pumps_to_kill = 8
export var enemy_layer = 2

var exploding_sound = preload("res://assets/sounds/explosion.wav")
var level_complete_sound = preload("res://assets/sounds/level_complete.wav")

var rng = RandomNumberGenerator.new()

var original_walk_speed = 60

var facing_left = true

export var base_score = 100

var collision_info
var player
var camera
var sprite
var score
var inflation = 0
var time_until_reset_pump = pump_reset_time

#Variables for the state of the baddie
var is_hunting = false
var is_ghosting = false
var is_wandering = false
var is_starting = true

#values for determining when to leave starting state
var starting_to_ghost_threshold = 8
var starting_to_ghost_value = 0

#variables to determine when to redirect ghost location
var more_accurate_ghost_threshold = 4
var more_accurate_ghost_value = 0

#variables to determine when to start ghosting
var hunting_to_ghost_threshold = 60
var hunting_to_ghost_value = 0

#variables to determine when to give up and unghost at the first movetile
var give_up_ghost_threshold = 4
var give_up_ghost_value = 0

#variables to recalculate the path
var recalculate_astar_threshold = 3
var recalcuate_astar_value = 0

var giving_up_ghost = false

var pump_scale_factor = 1.5 / pumps_to_kill
var moveable_neighbors
var current_path = []

#Length is referring to left_right size of block
export var starting_cell_height = 4
#width is referring to up_down size of block
export var starting_cell_width = 1
var up_down_motion = true
var right_or_down = true
	
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	#make enemies on later levels harder
	pumps_to_kill += global.current_level
	#Randomize certain values
	starting_to_ghost_threshold = rng.randf_range(3,9)
	hunting_to_ghost_threshold = rng.randf_range(18,24)
	global.num_baddies += 1
	set_collision_layer(enemy_layer)
	sprite_path = "./RedBaddieSprite"
	move_tiles = get_node(move_tiles_path)
	sprite = get_node(sprite_path)
	player = get_node(player_path)
	camera = get_node(camera_path)
	score = get_node(score_path)
	#Set walk speed, which is altered by powerups
	walk_speed = original_walk_speed
	normal_walk_speed = original_walk_speed
	in_transit = false
	current_cell = move_tiles.world_to_map(position)
	#initialize current path to nothing
	current_path = []
	add_to_group("baddies")

	#use the dimensions of the starting block to determine orientation
	if starting_cell_width < starting_cell_height:
		up_down_motion = false
	create_starter_room(starting_cell_width, starting_cell_height)
	if sprite != null:
		sprite.set_to_walk()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_walk_speed(delta)
	if inflation > 0: # Currently getting pumped
		#$TerrainCollision.set_deferred("disabled",true)
		time_until_reset_pump -= delta
		if time_until_reset_pump <= 0 and inflation < pumps_to_kill:
			time_until_reset_pump = pump_reset_time
			print("Decreasing inflation")
			inflation -= 1
			sprite.change_scale(Vector2(-1*pump_scale_factor,-1*pump_scale_factor))
			if inflation == 0: # Get out of pumping state
				print("No longer pumped.")
				sprite.set_to_walk()
				#$TerrainCollision.set_deferred("disabled",false)
				get_node(player_path).pumping = null

func _physics_process(delta):
	if (inflation == 0):
		if is_ghosting:
			ghost_motion(delta)
		elif is_starting:
			starter_motion(delta)
		elif is_hunting or is_wandering:
			a_star_motion(delta)

func create_starter_room(width, length):
	for w in range(0, width):
		for l in range(0, length):
			var cell = current_cell
			#dig out a cell and put it into move_tiles
			dirt_tiles.dig_out(cell + Vector2(l, w), dirt_tiles.ORIENT.HORIZ)
			move_tiles.add_moved_to_cell(cell + Vector2(l, w))
			dirt_tiles.dig_out(cell + Vector2(-l, -w), dirt_tiles.ORIENT.HORIZ)
			move_tiles.add_moved_to_cell(cell + Vector2(-l, -w))
			
func starter_motion(delta):
	sprite.set_to_walk()
	if not in_transit:
		#Use this range as a buffer to prevent clipping
		for i in range(-2,3):
			for j in range(-2,3):
				#Switch the direction
				if dirt_tiles.get_cellv(current_cell+Vector2(i,j)) != -1:
					right_or_down = not right_or_down
					break
		#Move based on direction
		if (up_down_motion):
			if right_or_down:
				move_to_cell(Vector2(current_cell.x,current_cell.y+1))
			else:
				move_to_cell(Vector2(current_cell.x,current_cell.y-1))
		else:
			if right_or_down:
				move_to_cell(Vector2(current_cell.x+1,current_cell.y))
			else:
				move_to_cell(Vector2(current_cell.x-1,current_cell.y))
	update_position()
	if (is_hunting):
		starting_to_ghost_value += delta
		if (starting_to_ghost_value >= starting_to_ghost_threshold):
			is_starting = false

func a_star_motion(delta):
	update_position()
	#If an enemy ends up off grid, make them ghost randomly
	if !move_tiles.is_cell_moved_to(current_cell):
		print("going ghost, current cell not in moved to set")
		move_to_cell(move_tiles.get_random_moved_to_cell())
		disable_collision_and_ghost()
		return
	#If there's no path...
	if current_path == null or current_path.size() == 0:
		print("calculating path")
		var dest_cell
		#Go ghost on a timer
		if (hunting_to_ghost_value >= hunting_to_ghost_threshold):
			print("going ghost on timer")
			hunting_to_ghost_value = 0
			move_to_cell(move_tiles.get_random_moved_to_cell())
			disable_collision_and_ghost()
			return
			#If hunting, path to the player
		if is_hunting:
			dest_cell = player.current_cell
			move_tiles.add_moved_to_cell(dest_cell)
		current_path = a_star(current_cell, dest_cell, move_tiles)
		#prevent backtracking
		if (current_path.size() > 0):
			current_path.remove(0)
		#unable to get to destination, then go ghost
		if (current_path.size() == 0):
			print("can't get to destination: going ghost!")
			current_path.clear()
			move_to_cell(dest_cell)
			disable_collision_and_ghost()
	else:
		#Eat through the path
		if !in_transit:
			move_to_cell(current_path[0])
			sprite.play_walking_animation(current_path[0]-current_cell)
			#Change directions
			if current_path[0]-current_cell == Vector2(-1,0):
				set_rotation_degrees(0)
			elif current_path[0]-current_cell == Vector2(1,0):
				set_rotation_degrees(180)
			if current_path.size() > 0:
				current_path.remove(0)
	
	#Is it time to recalculate? If so, clear path for next run to generate
	#path
	recalcuate_astar_value += delta
	if (recalcuate_astar_value >= recalculate_astar_threshold):
		print("clearing current path")
		current_path.clear()
		recalcuate_astar_value = 0
			
	hunting_to_ghost_value += delta
			
			
func ghost_motion(delta):
	#Make sure sprite is ghost
	if sprite.animation != "ghosting":
		sprite.set_to_ghost()
	update_position()
	#If at the point, unghost
	if (arrived()):
		enable_collision_and_unghost()
		more_accurate_ghost_value = 0
	#If giving up, then unghost on the first cell that's available
	elif giving_up_ghost:
		var hovering_cell = move_tiles.world_to_map(position)
		if hovering_cell in move_tiles.moved_to_cells:
			print("ungoing ghost, giving up")
			enable_collision_and_unghost()
			give_up_ghost_value = 0
			move_to_cell(hovering_cell)
			while (in_transit):
				update_position()
	more_accurate_ghost_value += delta
	give_up_ghost_value += delta
	#Change direction if necessary
	if (more_accurate_ghost_value >= more_accurate_ghost_threshold):
		more_accurate_ghost_value = 0
		move_to_cell(player.current_cell)
	if (give_up_ghost_value >= give_up_ghost_threshold):
		giving_up_ghost = true

func move_and_process(velocity):
	move_and_slide(velocity)
	#get collisions and if the collider is a player, kill them
	for i in range(get_slide_count()):
		var collision = get_slide_collision(i)
		if collision.collider.has_method("die_by_mob"):
			collision.collider.die_by_mob() # Kill the player

func disable_collision_and_ghost():
	walk_speed = original_walk_speed / 1.3
	print("going ghost!")
	is_ghosting = true
	#Disable hitbox and set sprite to ghost
	$TerrainCollision.set_deferred("disabled",true)
	sprite.set_to_ghost()

func enable_collision_and_unghost():
	walk_speed = original_walk_speed
	print("ungoing ghost!")
	giving_up_ghost = false
	is_ghosting = false
	#Enable hitbox and go back to normal sprite
	$TerrainCollision.set_deferred("disabled",false)
	sprite.set_to_walk()
	
func hit():
	#Set self to what the player is pumping and call pump
	get_node(player_path).pumping = self
	pump()

func pump():
	camera.small_shake()
	inflation += 1
	print("Current inflation: " + str(inflation))
	#Set animation if not set
	if sprite.animation != "pumping":
		sprite.set_to_pumped()
	time_until_reset_pump = pump_reset_time
	#Scale up
	sprite.change_scale(Vector2(pump_scale_factor,pump_scale_factor))
	if inflation >= pumps_to_kill:
		print("I am dead.")
		explode()

func explode():
	walk_speed = 0
	walk_speed_reset_time = 999
	die()

#Function for getting a multiplier bonus for the terrain layer
func get_layer_value():
	#Split the dirt into 4 quadrants
	var increment = move_tiles.max_y/4
	var y = current_cell.y
	if (y < increment):
		return 1
	elif y < increment*2:
		return 1.5
	elif y < increment*3:
		return 2
	else:
		return 2.5
		
	

func update_score():
	print("awarding player with layer value ", get_layer_value())
	score.update_score(base_score * get_layer_value())
	
func die():
	#disable collision
	$TerrainCollision.set_deferred("disabled",true)
	#unset the player as pumping something
	player.pumping = null
	#Play exploding sound and set sprite, wait till animation finishes
	$AudioStreamPlayer.stream = exploding_sound
	$AudioStreamPlayer.play()
	sprite.set_to_exploding()
	yield(sprite,"animation_finished")
	update_score()
	check_for_level_completion()
	#Tell fellow enemies to start hunting
	get_tree().call_group("baddies","start_hunting")
	queue_free()

func check_for_level_completion():
	#decrement baddie count
	global.num_baddies -= 1
	if (global.num_baddies == 0):
		print("level complete!")
		#Go to the next level or back to the start screen
		global.current_level += 1
		if global.current_level == 6:
			get_tree().change_scene("res://levels/StartingScreen.tscn")
		else:
			get_tree().change_scene("res://levels/level_" + str(global.current_level) + ".tscn")

func start_hunting():
	print("now hunting")
	is_hunting = true
	is_wandering = false

func squish():
	camera.small_shake()
	print("I am baddie and I am squished")
	#This is set to immobilize the baddie
	inflation = 999
	die()

func a_star(starting_cell,player_cell,move_tiles_instance):
	var frontier = preload("res://scripts/pq.gd").new()
	frontier.make()
	var previous = {starting_cell:null}
	var costs = {starting_cell:0}
	var visited = {}
	var potential_cost
	var to_visit
	var position
	var path = []
	frontier.push({cell=starting_cell,pqval=0})

	while not frontier.empty():
		var frontier_node = frontier.pop()
		to_visit = frontier_node.cell
		
		if to_visit in visited:
			continue

		visited[to_visit] = true

		if(to_visit == player_cell):
			path = []
			position = to_visit
			path.append(position)
			while previous[position] != null:
				path.insert(0,previous[position])
				position = previous[position]
			return path

		for neighbor in move_tiles_instance.get_moveable_neighbors(to_visit):
			potential_cost = costs[to_visit] + 1
			if neighbor in costs and costs[neighbor] <= potential_cost:
				continue
			costs[neighbor] = potential_cost
			previous[neighbor] = to_visit
			frontier.push({cell=neighbor,pqval=-1*potential_cost+move_tiles_instance.get_heuristic(neighbor,player_cell)})

	return path
