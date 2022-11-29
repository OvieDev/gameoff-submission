extends Node
var current_level = ""
var combo = 0
var post_process = true
var fps = 60
var music = 75
var sfx = 75
var unlocked = [true, false, false, false, false, false]


func _process(delta):
	print(Engine.target_fps)
	Engine.target_fps = fps
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), -50 + (music)/2)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), -50 + (sfx)/2)

