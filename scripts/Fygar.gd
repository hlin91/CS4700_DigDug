extends "res://scripts/RedBaddie.gd"

var fire = preload("res://scenes/FygarFire.tscn")
var fire_threshold = 10
var fire_value = 0
var breathing_fire = false

export var bullet_layer = 3

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	._ready()
	original_walk_speed = 75
	walk_speed = original_walk_speed
	sprite_path = "./FygarSprite"
	sprite = get_node(sprite_path)
	base_score = 800

func breathe_fire():
	var f = fire.instance()
	f.start($FirePosition.global_position, rotation)
	f.set_collision_layer(enemy_layer)
	var t = Timer.new()
	t.set_wait_time(1.5)
	t.set_one_shot(true)
	self.add_child(t)
	breathing_fire = true
	t.start()
	sprite.play_firing()
	yield(t, "timeout")
	if (inflation != 0):
		get_parent().add_child(f)
	t.set_wait_time(2.5)
	t.start()
	yield(t, "timeout")
	sprite.set_to_walk()
	t.queue_free()
	breathing_fire = false
	walk_speed = original_walk_speed

func _physics_process(delta):
	
	if breathing_fire:
		walk_speed = 0
	if (!is_ghosting):
		fire_value += delta
		if (fire_value >= fire_threshold):
			print("fygar breathing fire!")
			breathe_fire()
			fire_value = 0
			
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
