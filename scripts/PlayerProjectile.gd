extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (float) var speed = 100.0
var velocity = Vector2(speed, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	$PlayerProjectileSprite.set_rotation_degrees(90)

func start(pos, dir):
	rotation = dir
	position = pos
	velocity = Vector2(speed, 0).rotated(rotation)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.collider.has_method("hit"):
			collision.collider.hit()
		queue_free()
			
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
