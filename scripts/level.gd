extends Node2D
class_name Level

export var level_name := "Level name"

func _ready():
	GameManager.current_level = level_name
