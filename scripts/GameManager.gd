extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in get_tree().get_nodes_in_group("baddies"):
			connect("baddie_died",i,"_on_RedBaddie_baddie_died", [i.base_score, i.current_cell])

func _on_RedBaddie_baddie_died(base_score, current_cell):
	print("GM SAYS BADDIE DIED")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
