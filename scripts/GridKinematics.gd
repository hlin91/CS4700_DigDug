extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (float) var walk_speed = 50
export var move_tiles_path = "../MoveTiles"
export var dirt_tiles_path = "../DirtTiles"
export var power_up_duration = 4
var normal_walk_speed = 50
var walk_speed_reset_time = power_up_duration
var velocity = Vector2()
var current_position = Vector2()
var target_position = Vector2()
var move_direction = Vector2()
var current_cell = Vector2()
var target_cell = Vector2()
var start_cell = Vector2()
var epsilon = 1
var move_tiles # Tile map that represents the move grid
var dirt_tiles # Tile map that represents the dirt grid
var in_transit = false # Is the player currently moving to a cell

# Called when the node enters the scene tree for the first time.
func _ready():
	move_tiles = get_node(move_tiles_path)
	dirt_tiles = get_node(dirt_tiles_path)
	move_to_cell(start_cell)
	normal_walk_speed = walk_speed
	
func move(position): # Sets the target position
	in_transit = true
	target_position = position
	move_direction = (target_position - current_position).normalized()

func move_to_cell(cell): # Sets the target position based on cell
	if cell.x < move_tiles.min_x || cell.x > move_tiles.max_x:
		return
	if cell.y < move_tiles.min_y || cell.y > move_tiles.max_y:
		return
	move_cell_hook(cell)
	target_cell = cell
	if target_cell.x >= 0 && target_cell.y >= 0:
		move(move_tiles.map_to_world(cell) + (move_tiles.cell_size / 2))
	
func move_and_process(velocity): # Move and slide the body and process all collisions
	pass

func update_position():
	current_position = position
	current_cell = move_tiles.world_to_map(position)
	if arrived():
		in_transit = false
		move_direction = Vector2()
		arrived_hook(current_cell)
	else:
		move(target_position)
	velocity = move_direction.normalized() * walk_speed
	move_and_process(velocity)

func arrived():
	return (target_position - current_position).length() <= epsilon

func arrived_hook(cell):
	pass
	
func move_cell_hook(cell):
	pass

func update_walk_speed(delta):
	if walk_speed == normal_walk_speed:
		walk_speed_reset_time = power_up_duration
	if walk_speed != normal_walk_speed:
		walk_speed_reset_time -= delta
		if walk_speed_reset_time <= 0:
			walk_speed = normal_walk_speed
			walk_speed_reset_time = power_up_duration

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
