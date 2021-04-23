extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (float) var walk_speed = 10000
export var min_x = 2 # Min horizontal index for cells
export var max_x = 126 # Max horizontal index for cells
export var min_y = 2 # Min vertical index for cells
export var max_y = 72 # Max vertical index for cells
export var move_tiles_path = "../MoveTiles"
export var dirt_tiles_path = "../DirtTiles"
export var sprite_path = "./PlayerSprite"
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
var sprite # Reference to the player sprite
var in_transit = false # Is the player currently moving to a cell

# Called when the node enters the scene tree for the first time.
func _ready():
	move_tiles = get_node(move_tiles_path)
	dirt_tiles = get_node(dirt_tiles_path)
	sprite = get_node(sprite_path)
	move_to_cell(start_cell)
	
func move(position): # Sets the target position
	in_transit = true
	target_position = position
	move_direction = (target_position - current_position).normalized()

func move_to_cell(cell): # Sets the target position based on cell
	if cell.x < min_x || cell.x > max_x:
		return
	if cell.y < min_y || cell.y > max_y:
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
