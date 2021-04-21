extends "res://scripts/GridKinematics.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var bullet_layer = 2
var game_over = false
var bullet = preload("res://scenes/PlayerProjectile.tscn")
var max_bullets = 1
var pumping = null # Enemy the player is currently pumping
var orientation
	
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

func _ready():
	._ready()
	orientation = dirt_tiles.ORIENT.HORIZ

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!game_over):
		if !in_transit && Input.is_action_just_pressed("shoot"):
			if pumping != null:
				pumping.pump()
			else:
				shoot()

func _physics_process(delta):
	if (!game_over):
		get_input()
		update_position()

func move_and_process(velocity):
	move_and_slide(velocity)
	if get_slide_count() > 0:
		in_transit = false
		move_direction = Vector2()
		arrived_hook()
#	for i in range(get_slide_count()):
#		var collision = get_slide_collision(i)
#		if collision.collider is TileMap:
#			var collision_pos = collision.position - collision.normal * 1.0
##			print("Collision pos:" + str(collision_pos))
#			var tile_pos = collision.collider.world_to_map(collision_pos)
##			print("Tile pos: " + str(tile_pos))
#			if !move_tiles.is_cell_movable(tile_pos):
#				collision.collider.set_cellv(tile_pos, -1)
#		else: # Collided with a rock. Stop movement
#			in_transit = false
#			move_direction = Vector2()
#			arrived_hook()

func move_cell_hook(cell):
	move_tiles.add_moved_to_cell(cell)
	dirt_tiles.dig_out(cell, orientation)

func shoot():
	if get_tree().get_nodes_in_group("bullets").size() < max_bullets:
		var b = bullet.instance()
		b.set_collision_mask_bit(bullet_layer-1, true)
		b.set_collision_layer_bit(0, false)
		b.set_collision_mask_bit(0, false)
		b.set_collision_layer_bit(bullet_layer-1, true)
		b.set_collision_mask_bit(bullet_layer-1, true)
		b.start($Muzzle.global_position, rotation)
		get_parent().add_child(b)

func get_input():
	if !in_transit:
		if Input.is_action_pressed("move_right"):
			orientation = dirt_tiles.ORIENT.HORIZ
			pumping = null
			move_to_cell(Vector2(current_cell.x+1, current_cell.y))
			sprite.move_animation(sprite.DIR.RIGHT)
			set_rotation_degrees(0)
		elif Input.is_action_pressed("move_left"):
			orientation = dirt_tiles.ORIENT.HORIZ
			pumping = null
			move_to_cell(Vector2(current_cell.x-1, current_cell.y))
			sprite.move_animation(sprite.DIR.LEFT)
			set_rotation_degrees(-180)
		elif Input.is_action_pressed("move_down"):
			orientation = dirt_tiles.ORIENT.VERT
			pumping = null
			move_to_cell(Vector2(current_cell.x, current_cell.y+1))
			sprite.move_animation(sprite.DIR.DOWN)
			set_rotation_degrees(-270)
		elif Input.is_action_pressed("move_up"):
			orientation = dirt_tiles.ORIENT.VERT
			pumping = null
			move_to_cell(Vector2(current_cell.x,current_cell.y-1))
			sprite.move_animation(sprite.DIR.UP)
			set_rotation_degrees(-90)

func arrived_hook():
	sprite.moving = false
	if !(Input.is_action_pressed("move_right") || Input.is_action_pressed("move_left") ||
		 Input.is_action_pressed("move_down") || Input.is_action_pressed("move_up")):
			sprite.clear_animation()

func squish():
	kill()

func _on_PlayerHurtbox_area_entered(area):
	kill()

func kill():
	print("Player died")
	get_tree().change_scene("./Test_Scene_1.tscn")
