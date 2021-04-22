extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in get_tree().get_nodes_in_group("baddies"):
			connect("baddie_died",i,"_update_score")

func update_score(base_score, current_cell):
	print(base_score)
	print(current_cell)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
