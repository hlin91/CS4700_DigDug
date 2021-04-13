extends "res://scripts/GridKinematics.gd"

export var player_path = "../Player"
export var player_layer_bit = 0
export var enemy_layer_bit = 1
var player

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node(player_path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
