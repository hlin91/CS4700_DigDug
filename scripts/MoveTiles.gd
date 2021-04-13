extends TileMap

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var movable_cells = {}

func add_dug_cell(cell):
	movable_cells[cell] = true
	print("Added cell " + str(cell))
	
func is_cell_dug(cell):
	if cell.y == 0: # Topmost level is always dug out
		return true
	return cell in movable_cells
	
func get_moveable_neighbors(cell):
	var moveable_neighbors = []
	var neighbors = []
	neighbors.append(cell+Vector2(1,0))
	neighbors.append(cell+Vector2(-1,0))
	neighbors.append(cell+Vector2(0,-1))
	neighbors.append(cell+Vector2(0,1))
	for neighbor in neighbors:
		if is_cell_dug(neighbor):
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
		

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
