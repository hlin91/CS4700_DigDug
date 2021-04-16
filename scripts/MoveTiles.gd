extends TileMap

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var min_x = 0 # Min horizontal index for cells
export var max_x = 100 # Max horizontal index for cells
export var min_y = 100 # Min vertical index for cells
export var max_y = 100 # Max vertical index for cells
export var dirt_tiles_path = "../DirtTiles"
var dirt_tiles
var moved_to_cells = {} # Cells that the player has explicitly moved to

func _ready():
	dirt_tiles = get_node(dirt_tiles_path)

func add_moved_to_cell(cell):
	if !cell in moved_to_cells:
		moved_to_cells[cell] = true
	
func is_cell_movable(cell):
	return dirt_tiles.get_cellv(cell) == -1
	
func get_moveable_neighbors(cell):
	var moveable_neighbors = []
	var neighbors = []
	neighbors.append(cell+Vector2(1,0))
	neighbors.append(cell+Vector2(-1,0))
	neighbors.append(cell+Vector2(0,-1))
	neighbors.append(cell+Vector2(0,1))
	for neighbor in neighbors:
		if is_cell_moved_to(neighbor):
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
	
func get_random_moved_to_cell():
	var values = moved_to_cells.keys()
	return values[randi() % values.size()]
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
