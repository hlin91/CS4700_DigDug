extends "res://scripts/GridKinematics.gd"

export var player_layer_bit = 0
export var enemy_layer_bit = 1
export var tolerance = 3
export var player_path = "../Player"
export var sprite_path = "RockSprite"
var player
var sprite
var dropped = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	current_cell = move_tiles.world_to_map(position)
	target_cell = current_cell
	current_position = move_tiles.map_to_world(current_cell) + (move_tiles.cell_size/2)
	target_position = current_position
	position = current_position
	set_collision_mask_bit(player_layer_bit, true)
	set_collision_mask_bit(enemy_layer_bit, true)
	player = get_node(player_path)
	sprite = get_node(sprite_path)

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
	drop_rock()

func arrived_hook(cell):
	# TODO: Play crumbling animation
	queue_free()

func cell_in_range(cell):
	var x_offset = -tolerance
	while x_offset <= tolerance:
		if move_tiles.is_cell_moved_to(Vector2(cell.x + x_offset, cell.y)):
			return true
		x_offset += 1
	return false

func _on_Area2D_area_shape_exited(area_id, area, area_shape, self_shape):
	# Scan all cells below the rock for a cell the player has already traversed
	# to fall down to
	drop_rock()
	
func drop_rock():
	var cell = null
	var y_pos = current_cell.y + 1
	var candidate = null
	while y_pos <= move_tiles.max_y:
		candidate = Vector2(current_cell.x, y_pos)
		if cell_in_range(candidate):
			cell = candidate
			break
		y_pos += 1
	if cell != null:
		candidate = Vector2(cell.x, cell.y+1)
		while candidate.y <= move_tiles.max_y && cell_in_range(candidate):
			cell = candidate
			candidate.y += 1
		sprite.play("shake")
		yield(get_tree().create_timer(.3), "timeout")
#		sprite.play("default")
		dropped = true
#		print("Dropping to: " + str(cell))
		move_to_cell(cell)
	return cell != null


func _on_Area2D_body_exited(body):
	if body == player:
		drop_rock()
