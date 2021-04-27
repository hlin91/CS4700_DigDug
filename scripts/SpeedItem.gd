extends "res://scripts/Item.gd"

export var increased_speed = 100

func pick_up():
	player.walk_speed = increased_speed
