extends Area2D
signal dug

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TileArea_area_entered(area):
	hide()
	emit_signal("dug")
	#$CollisionShape2D.set_deferred("disabled", true)
