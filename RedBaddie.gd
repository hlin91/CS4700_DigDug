extends "res://scripts/GridKinematics.gd"

# Declare member variables here. Examples:
export var player_path = "../Player"
export var pump_reset_time = 1.5
export var pumps_to_kill = 8
export var enemy_layer = 2
var collision_info
var player
var inflation = 0
var time_to_track = 0
var time_to_track_threshold = 100
var time_to_hunt = 0
var time_to_hunt_threshold = 3
var current_time = 0
var time_until_reset_pump = pump_reset_time
var is_hunting = false
var is_ghosting = false
#track is referring to the trail left behind by spaces the player has explicitly
#moved to
var is_tracking = false
var pump_scale_factor = 1.5 / pumps_to_kill
var moveable_neighbors
var current_path = []

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
	time_to_hunt += delta
	if (time_to_hunt >= time_to_hunt_threshold):
		is_hunting = true
		time_to_hunt = 0
		print("starting to hunt")
	
func on_track_motion(delta):
	if (!in_transit):
		var moveable_neighbors = move_tiles.get_moveable_neighbors(current_cell)
		var chosen_neighbor
		collision_info = move_and_collide(velocity*0)
		if (moveable_neighbors.size() == 0 or collision_info):
			chosen_neighbor = move_tiles.get_random_moved_to_cell()
			disable_collision_and_ghost()
			move_to_cell(chosen_neighbor)
		else:
			chosen_neighbor = moveable_neighbors[randi() % moveable_neighbors.size()]
			move_to_cell(chosen_neighbor)
		update_position()
	else:
		update_position()
	time_to_hunt += delta
	if (time_to_hunt >= time_to_hunt_threshold):
		time_to_hunt = 0
		is_hunting = true
		is_tracking = false
		print("starting to hunt")

#func naive_hunt_motion(delta):
#	if (!in_transit):
#		moveable_neighbors = move_tiles.get_moveable_neighbors(current_cell)
#	collision_info = move_and_collide(velocity*0)
#	if (moveable_neighbors.size() == 0 or collision_info): #case for being trapped in cell at hunt time
#		move_to_cell(move_tiles.get_random_moved_to_cell())
#		disable_collision_and_ghost()
#	else:
#		if (!in_transit):
#			move_to_cell(move_tiles.get_nearest_neighbor(moveable_neighbors,player.current_cell))
#		update_position()
#	time_to_track += delta
#	if (time_to_track >= time_to_track_threshold):
#		time_to_track = 0
#		is_tracking = true
#		is_hunting = false
#		print("starting to track")

func a_star_hunt_motion(delta):
	if (!move_tiles.is_cell_moved_to(current_cell)):
		print("going ghost")
		is_ghosting = true
		return
	if current_path.size() == 0:
		current_path = a_star(current_cell, player.current_cell,move_tiles)
		print(current_path)
	else:
		if !in_transit:
			move_to_cell(current_path[0])
			current_path.remove(0)
		else:
			update_position()

func ghost_motion(delta):
	update_position()
	if (arrived()):
		enable_collision_and_unghost()
		velocity = Vector2(1,0)

func a_star(starting_cell,player_cell,move_tiles_instance):
	var frontier = preload("res://pq.gd").new()
	frontier.make()
	var previous = {starting_cell:null}
	var costs = {starting_cell:0}
	var visited = {}
	var potential_cost
	var to_visit
	var position
	var path
	frontier.push({cell=starting_cell,pqval=0})
	
	while not frontier.empty():
		var frontier_node = frontier.pop()
		print(frontier_node)
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
			
		
func _physics_process(delta):
	if (inflation == 0):
		if (is_ghosting == false): #case for standard "non-ghosting" movement
			if (is_hunting):
				a_star_hunt_motion(delta)
			elif not is_tracking: #using grid movement to go to player tile.
				normal_motion(delta)
			else:
				on_track_motion(delta)
		else: #case for being a ghost in transit
			ghost_motion(delta)

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
		
