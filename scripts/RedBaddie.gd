extends "res://scripts/GridKinematics.gd"

# Declare member variables here. Examples:

signal baddie_died(base_score,current_cell)

export var player_path = "../Player"
export var score_path = "../Score"
export var pump_reset_time = 1.5
export var pumps_to_kill = 8
export var enemy_layer = 2

export var base_score = 100

var collision_info
var player
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
var more_accurate_ghost_threshold = 2
var more_accurate_ghost_value = 0

var hunting_to_ghost_threshold = 8
var hunting_to_ghost_value = 0

var pump_scale_factor = 1.5 / pumps_to_kill
var moveable_neighbors
var current_path = []

#Length is referring to left_right size of block
export var starting_block_left_to_right = 5
#width is referring to up_down size of block
export var starting_block_down_to_up = 14
var up_down_motion = true
var right_or_down = true
	
# Called when the node enters the scene tree for the first time.
func _ready():
	set_collision_layer(enemy_layer)
	sprite_path = "./RedBaddieSprite"
	move_tiles = get_node(move_tiles_path)
	sprite = get_node(sprite_path)
	player = get_node(player_path)
	score = get_node(score_path)
	walk_speed = 50
	in_transit = false
	current_cell = move_tiles.world_to_map(position)
	current_path = []
	add_to_group("baddies")

	#use the dimensions of the starting block to determine orientation
	if starting_block_left_to_right > starting_block_down_to_up:
		up_down_motion = false
	create_starter_room(starting_block_left_to_right,starting_block_down_to_up)
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
				
func create_starter_room(length,width):
	var cell
	for l in range((length*-1)/2,length/2):
		for w in range((width*-1)/2,width/2):
			cell = Vector2(l,w) + current_cell
			if cell.x < 0 or cell.y < 0:
				continue
			dirt_tiles.atomic_dig_out(cell)

func starter_motion(delta):
	if not in_transit:
		if dirt_tiles.get_cellv(current_cell) != -1:
			right_or_down = not right_or_down
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
	starting_to_ghost_value += delta
	if (starting_to_ghost_value >= starting_to_ghost_threshold):
		disable_collision_and_ghost()
		is_wandering = true
		move_to_cell(move_tiles.get_random_moved_to_cell())
	

func a_star_motion(delta):
	if (!move_tiles.is_cell_moved_to(current_cell)):
		print("going ghost")
		move_to_cell(move_tiles.get_random_moved_to_cell())
		disable_collision_and_ghost()
		return
	if current_path == null or current_path.size() == 0:
		var dest_cell
		if (hunting_to_ghost_value >= hunting_to_ghost_threshold):
			hunting_to_ghost_value = 0
			move_to_cell(move_tiles.get_random_moved_to_cell())
			disable_collision_and_ghost()
			return
		if is_hunting:
			dest_cell = player.current_cell
		elif is_wandering:
			dest_cell = move_tiles.get_random_moved_to_cell()
		current_path = a_star(current_cell, dest_cell, move_tiles)
	else:
		if !in_transit:
			move_to_cell(current_path[0])
			if current_path.size() > 0:
				current_path.remove(0)
		else:
			update_position()
	hunting_to_ghost_value += delta
			

func ghost_motion(delta):
	update_position()
	if (arrived()):
		enable_collision_and_unghost()
		more_accurate_ghost_value = 0
	more_accurate_ghost_value += delta
	if (more_accurate_ghost_value >= more_accurate_ghost_threshold):
		more_accurate_ghost_value = 0
		move_to_cell(player.current_cell)

func _physics_process(delta):
	if (inflation == 0):
		if is_ghosting:
			ghost_motion(delta)
		elif is_hunting or is_wandering:
			a_star_motion(delta)
		elif is_starting:
			starter_motion(delta)

func move_and_process(velocity):
	move_and_slide(velocity)
	for i in range(get_slide_count()):
		var collision = get_slide_collision(i)
		if collision.collider.has_method("die_by_mob"):
			collision.collider.die_by_mob() # Kill the player

func disable_collision_and_ghost():
	walk_speed = 50
	print("going ghost!")
	is_ghosting = true
	$TerrainCollision.set_deferred("disabled",true)
	$RedBaddieHurtArea/RedBaddieHurtAreaShape.set_deferred("disabled",true)
	sprite.set_to_ghost()

func enable_collision_and_unghost():
	walk_speed = 50
	print("ungoing ghost!")
	is_ghosting = false
	$TerrainCollision.set_deferred("disabled",false)
	$RedBaddieHurtArea/RedBaddieHurtAreaShape.set_deferred("disabled",false)
	sprite.set_to_walk()
	
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
		emit_signal("baddie_died",base_score,current_cell)
		update_score()
		player.pumping = null
		queue_free()

func update_score():
	get_tree().call_group("baddies","start_hunting")
	score.update_score(base_score)

func start_hunting():
	print("now hunting")
	is_hunting = true
	is_wandering = false
	
#func _on_RedBaddieHurtArea_area_shape_entered(area_id, area, area_shape, self_shape):
#	pass # Replace with function body.
#	#case 1: it's the player
#		#do nothing
#	#case 2: it's a projectile
#		#increment inflation
#		#check if inflation meets threshold for death
#			#self.queue_free()

func squish():
	print("I am baddie and I am squished")
	emit_signal("baddie_died",base_score,current_cell)
	update_score()
	queue_free()

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
			frontier.push({cell=neighbor,pqval=potential_cost+move_tiles_instance.get_heuristic(neighbor,player_cell)})
