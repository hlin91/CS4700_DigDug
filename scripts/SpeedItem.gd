extends "res://scripts/Item.gd"

export var increased_speed = 115

func pick_up():
	player.walk_speed = increased_speed
