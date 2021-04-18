extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var tunnel_radius = 1

enum ORIENT {
	VERT,
	HORIZ
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func dig_out(cell, orient):
	var offset = 0
	if orient == ORIENT.VERT:
		# Dig out horizontally
		while offset < tunnel_radius:
			for y_offset in range(tunnel_radius):
				set_cellv(Vector2(cell.x + offset, cell.y + y_offset), -1)
				set_cellv(Vector2(cell.x - offset, cell.y + y_offset), -1)
				set_cellv(Vector2(cell.x + offset, cell.y - y_offset), -1)
				set_cellv(Vector2(cell.x - offset, cell.y - y_offset), -1)
			offset += 1
	elif orient == ORIENT.HORIZ:
		# Dig out vertically
		while offset < tunnel_radius:
			for x_offset in range(tunnel_radius):
				set_cellv(Vector2(cell.x + x_offset, cell.y + offset), -1)
				set_cellv(Vector2(cell.x + x_offset, cell.y - offset), -1)
				set_cellv(Vector2(cell.x - x_offset, cell.y + offset), -1)
				set_cellv(Vector2(cell.x - x_offset, cell.y - offset), -1)
			offset += 1
	else:
		print("DirtTiles: dig_out: invalid orientation passed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
