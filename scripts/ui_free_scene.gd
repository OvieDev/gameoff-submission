extends Control
class_name UIFreeScene

func _ready():
	Gui.visible = false
	PauseMenu.can_be_paused = false
	PauseMenu.visible = false
	DeathScreen.visible = false
	var m = AudioServer.get_bus_index("Music")
	var s = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_mute(m, false)
	AudioServer.set_bus_mute(s, false)
	get_tree().paused = false
	
