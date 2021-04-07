extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (float) var walk_speed = 1
var velocity = Vector2()
var current_position = Vector2()
var target_position = Vector2()
var move_direction = Vector2()
var current_cell = Vector2()
var target_cell = Vector2()
var start_cell = Vector2()
var epsilon = 1
var move_tiles
var sprite
var in_transit = false

# Called when the node enters the scene tree for the first time.
func _ready():
	move_tiles = get_node("../MoveTiles")
	sprite = get_node("./PlayerSprite")
	move_to_cell(start_cell)

func move(position):
	in_transit = true
	target_position = position
	move_direction = (target_position - current_position).normalized()

func move_to_cell(cell):
	target_cell = cell
	move(move_tiles.map_to_world(cell) + (move_tiles.cell_size / 2))
	
func move_and_dig(velocity):
	move_and_slide(velocity)
	for i in range(get_slide_count()):
		var collision = get_slide_collision(i)
		if collision.collider is TileMap:
			var tile_pos = collision.collider.world_to_map(collision.position - collision.normal)
			collision.collider.set_cellv(tile_pos, -1)

func update_position():
	current_position = position
	current_cell = move_tiles.world_to_map(position)
	if (target_position - current_position).length() <= epsilon:
		in_transit = false
		move_direction = Vector2()
		sprite.moving = false
		if !(Input.is_action_pressed("move_right") || Input.is_action_pressed("move_left") ||
		 Input.is_action_pressed("move_down") || Input.is_action_pressed("move_up")):
			sprite.clear_animation()
	else:
		move(target_position)
	velocity = move_direction.normalized() * walk_speed
	move_and_dig(velocity)
	
#func get_input():
#	velocity = Vector2()
#	if Input.is_action_pressed("move_right"):
#		velocity = Vector2(1, 0)
#	elif Input.is_action_pressed("move_left"):
#		velocity = Vector2(-1, 0)
#	elif Input.is_action_pressed("move_down"):
#		velocity = Vector2(0, 1)
#	elif Input.is_action_pressed("move_up"):
#		velocity = Vector2(0, -1)
#	velocity = velocity.normalized() * walk_speed

func get_input():
	if !in_transit:
		if Input.is_action_pressed("move_right"):
			move_to_cell(Vector2(current_cell.x+1, current_cell.y))
			sprite.move_animation(sprite.DIR.RIGHT)
		elif Input.is_action_pressed("move_left"):
			move_to_cell(Vector2(current_cell.x-1, current_cell.y))
			sprite.move_animation(sprite.DIR.LEFT)
		elif Input.is_action_pressed("move_down"):
			move_to_cell(Vector2(current_cell.x, current_cell.y+1))
			sprite.move_animation(sprite.DIR.DOWN)
		elif Input.is_action_pressed("move_up"):
			move_to_cell(Vector2(current_cell.x,current_cell.y-1))
			sprite.move_animation(sprite.DIR.UP)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	get_input()
	update_position()


func _on_PlayerHurtbox_area_entered(area):
	pass # Replace with function body.
	#do some kind of logic related to life and restarting (somehow)
