extends AnimatedSprite


export var player_path = "../Player"
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node(player_path)

# Function that gets called on pickup
func pick_up():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Area2D_body_entered(body):
	if body == player:
		pick_up()
		queue_free()
