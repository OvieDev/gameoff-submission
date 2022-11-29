extends Control
class_name UIFreeScene

func _ready():
	Gui.visible = false
	PauseMenu.can_be_paused = false
	PauseMenu.visible = false
	get_tree().paused = false
	
