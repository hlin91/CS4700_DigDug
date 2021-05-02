extends "res://scripts/GridKinematics.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var shoot_sound = preload("res://assets/sounds/shoot.wav")
var pump_sound = preload("res://assets/sounds/pump.wav")
var death_sound = preload("res://assets/sounds/death_sound.wav")

export var bullet_layer = 3
export var enemy_layer = 2
export var start_x = 2
export var start_y = 2
export var game_over_scene = "res://levels/level_1.tscn"
export var sprite_path = "./PlayerSprite"
export var lives_path = "../Lives"
var lives
export var shoot_animation_persist = .1
var sprite = null
var game_over = false
var bullet = preload("res://scenes/PlayerProjectile.tscn")
var max_bullets = 1
var pumping = null # Enemy the player is currently pumping
var orientation

func _ready():
	._ready()
	lives = get_node(lives_path)
	sprite = get_node(sprite_path)
	orientation = dirt_tiles.ORIENT.HORIZ
	move_to_cell(Vector2(start_x, start_y))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!game_over):
		if !in_transit && Input.is_action_just_pressed("shoot"):
			if pumping != null:
				sprite.play_pumping_animation()
				$AudioStreamPlayer.stream = pump_sound
				$AudioStreamPlayer.play()
				pumping.pump()
			else:
				sprite.play_shooting_animation()
				shoot()
		elif pumping == null && (sprite.animation == "hero_shoot" || sprite.animation == "hero_pumping"):
			yield(get_tree().create_timer(shoot_animation_persist), "timeout")
			sprite.clear_animation()
	update_walk_speed(delta)

func _physics_process(delta):
	if (!game_over):
		get_input()
		update_position()

func move_and_process(velocity):
	if sprite.digging:
		$DirtParticles.turn_on()
	move_and_slide(velocity)
	if get_slide_count() > 0:
		in_transit = false
		move_direction = Vector2()
		arrived_hook(current_cell)

func move_cell_hook(cell):
	pass

func shoot():
	if get_tree().get_nodes_in_group("bullets").size() < max_bullets:
		$AudioStreamPlayer.stream = shoot_sound
		$AudioStreamPlayer.play()
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
	sprite.digging = dirt_tiles.dig_out(cell, orientation)
	sprite.moving = false
	if !(Input.is_action_pressed("move_right") || Input.is_action_pressed("move_left") ||
		 Input.is_action_pressed("move_down") || Input.is_action_pressed("move_up")):
		if sprite.animation != "hero_shoot" && sprite.animation != "hero_pumping":
			sprite.clear_animation()

func squish():
	print("the player is squished :(")
	kill()

func die_by_mob():
	print("the player was killed by a mob")
	kill()

func kill():
	print("Player died")
	current_cell = Vector2(start_x,start_y)
	position = Vector2(start_x,start_y)
	move_to_cell(Vector2(start_x,start_y))
	lives.decrement_lives()
