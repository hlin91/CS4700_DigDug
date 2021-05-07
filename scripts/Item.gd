extends AnimatedSprite


var powerup_noise = preload("res://assets/sounds/powerup.wav")
export var player_path = "../Player"
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node(player_path)

# Function that gets called on pickup
func pick_up():
	print("playing audio")
	$AudioStreamPlayer.stream = powerup_noise
	$AudioStreamPlayer.play()
