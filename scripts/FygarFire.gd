extends KinematicBody2D

var velocity = Vector2(0, 0)
var disappear_threshold = 1
var disappear_value = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.collider.has_method("die_by_mob"):
			collision.collider.die_by_mob()
	disappear_value += delta
	if (disappear_value >= disappear_threshold):
		queue_free()
		
func start(pos, dir):
	rotation = dir
	position = pos
	velocity = Vector2(0, 0).rotated(rotation)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
