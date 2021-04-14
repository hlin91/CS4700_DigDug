extends TileMap

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var min_x = 0 # Min horizontal index for cells
export var max_x = 100 # Max horizontal index for cells
export var min_y = 100 # Min vertical index for cells
export var max_y = 100 # Max vertical index for cells
var dugged_cells = {} # Cells that the player has dug
var moved_to_cells = {} # Cells that the player has explicitly moved to

func add_dug_cell(cell):
	if !cell in dugged_cells:
		dugged_cells[cell] = true
#		print("Dug cell " + str(cell))

func add_moved_to_cell(cell):
	if !cell in moved_to_cells:
		moved_to_cells[cell] = true
#		print("Moved to cell " + str(cell))
	
func is_cell_movable(cell):
	if cell.y == 0: # Topmost level is always dug out
		return true
	return cell in dugged_cells
	
func get_moveable_neighbors(cell):
	var moveable_neighbors = []
	var neighbors = []
	neighbors.append(cell+Vector2(1,0))
	neighbors.append(cell+Vector2(-1,0))
	neighbors.append(cell+Vector2(0,-1))
	neighbors.append(cell+Vector2(0,1))
	for neighbor in neighbors:
		#if is_cell_movable(neighbor):
		moveable_neighbors.append(neighbor)
	return moveable_neighbors

func get_nearest_neighbor(neighbors, cell):
	var n
	var min_distance = 9223372036854775807
	for neighbor in neighbors:
		if cell.distance_to(neighbor) < min_distance:
			n = neighbor
			min_distance = cell.distance_to(neighbor)
	return n

func is_cell_moved_to(cell):
	return cell in moved_to_cells

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
