extends "res://scripts/GridKinematics.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var bullet_layer = 3
export var enemy_layer = 2
export var start_x = 2
export var start_y = 2
export var game_over_scene = "res://levels/level_1.tscn"
export var sprite_path = "./PlayerSprite"
var sprite = null
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
	sprite = get_node(sprite_path)
	orientation = dirt_tiles.ORIENT.HORIZ
	move_to_cell(Vector2(start_x, start_y))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!game_over):
		if !in_transit && Input.is_action_just_pressed("shoot"):
			sprite.play_pumping_animation()
			if pumping != null:
				pumping.pump()
			else:
				shoot()
	if pumping == null and sprite.animation == "hero_pumping":
		sprite.clear_animation()

func _physics_process(delta):
	if (!game_over):
		get_input()
		update_position()

func move_and_process(velocity):
	move_and_slide(velocity)
	if get_slide_count() > 0:
		in_transit = false
		move_direction = Vector2()
		arrived_hook(current_cell)
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
	pass

func shoot():
	if get_tree().get_nodes_in_group("bullets").size() < max_bullets:
		var b = bullet.instance()
		b.set_collision_layer_bit(0, false)
		b.set_collision_mask_bit(0, false)
		b.set_collision_layer_bit(bullet_layer-1, true)
		b.set_collision_mask_bit(bullet_layer-1, true)
		b.set_collision_layer_bit(enemy_layer-1, true)
		b.set_collision_mask_bit(enemy_layer-1, true)
		b.start($Muzzle.global_position, rotation)
		get_parent().add_child(b)

func get_input():
	if Input.is_action_pressed("move_right"):
		move_right()
	elif Input.is_action_pressed("move_left"):
		move_left()
	elif Input.is_action_pressed("move_down"):
		move_down()
	elif Input.is_action_pressed("move_up"):
		move_up()

func move_right():
	if in_transit:
		return
	orientation = dirt_tiles.ORIENT.HORIZ
	pumping = null
	move_to_cell(Vector2(current_cell.x+1, current_cell.y))
	sprite.move_animation(sprite.DIR.RIGHT)
	set_rotation_degrees(0)

func move_left():
	if in_transit:
		return
	orientation = dirt_tiles.ORIENT.HORIZ
	pumping = null
	move_to_cell(Vector2(current_cell.x-1, current_cell.y))
	sprite.move_animation(sprite.DIR.LEFT)
	set_rotation_degrees(-180)

func move_down():
	if in_transit:
		return
	orientation = dirt_tiles.ORIENT.VERT
	pumping = null
	move_to_cell(Vector2(current_cell.x, current_cell.y+1))
	sprite.move_animation(sprite.DIR.DOWN)
	set_rotation_degrees(-270)

func move_up():
	if in_transit:
		return
	orientation = dirt_tiles.ORIENT.VERT
	pumping = null
	move_to_cell(Vector2(current_cell.x,current_cell.y-1))
	sprite.move_animation(sprite.DIR.UP)
	set_rotation_degrees(-90)

func arrived_hook(cell):
	move_tiles.add_moved_to_cell(cell)
	dirt_tiles.dig_out(cell, orientation)
	sprite.moving = false
	if !(Input.is_action_pressed("move_right") || Input.is_action_pressed("move_left") ||
		 Input.is_action_pressed("move_down") || Input.is_action_pressed("move_up")):
			if sprite.animation != "hero_pumping":
				sprite.clear_animation()

func squish():
	print("the player is squished :(")
	kill()

func die_by_mob():
	print("the player was killed by a mob")
	kill()

func kill():
	print("Player died")
	get_tree().change_scene(game_over_scene)
