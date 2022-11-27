extends Node2D
class_name Level

export var level_name := "Level name"

func _ready():
	GameManager.current_level = level_name
	Gui.visible = true
	PauseMenu.can_be_paused = true
	DeathScreen.visible = false
