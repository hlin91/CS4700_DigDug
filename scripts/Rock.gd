extends "res://scripts/GridKinematics.gd"

export var tiles_path = "../MoveTiles"
export var player_layer_bit = 0
export var enemy_layer_bit = 1
var tiles
var dropped = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	tiles = get_node(tiles_path)
	current_position = position
	target_position = position
	current_cell = tiles.world_to_map(position)
	target_cell = current_cell
	set_collision_mask_bit(player_layer_bit, true)
	set_collision_mask_bit(enemy_layer_bit, true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	if dropped:
		update_position()
		
func move_and_process(velocity):
	move_and_slide(velocity)
	for i in range(get_slide_count()):
		var collision = get_slide_collision(i)
		if collision.collider.has_method("squish"):
			collision.collider.squish() # squish players and enemies it collides with

func arrived_hook():
	# TODO: Play crumbling animation
	queue_free()

func _on_Area2D_area_shape_exited(area_id, area, area_shape, self_shape):
	# Scan all cells below the rock for a cell the player has already traversed
	# to fall down to
	var cell = null
	var y_pos = current_cell.y + 1
	while y_pos <= tiles.max_y:
		var candidate = Vector2(current_cell.x, y_pos)
		if tiles.is_cell_moved_to(candidate) || tiles.is_cell_moved_to(candidate+Vector2(-1, 0)) || tiles.is_cell_moved_to(candidate+Vector2(1, 0)):
			cell = candidate
		y_pos += 1
	if cell != null:
		# TODO: Play shaking animation
		dropped = true
		move_to_cell(cell)
