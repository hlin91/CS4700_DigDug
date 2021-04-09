extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var movable_cells = {}

func add_dug_cell(cell):
	movable_cells[cell] = true
	print("Added cell " + str(cell))
	
func is_cell_dug(cell):
	return cell in movable_cells

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
