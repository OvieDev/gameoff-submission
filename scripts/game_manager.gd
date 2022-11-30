extends Node
var current_level = ""
var combo = 0
var post_process = true
var fps = 60
var music = 75
var sfx = 75
var unlocked = [true, false, false, false, false, false]


func _ready():
	var save = File.new()
	save.open("user://data.save", File.READ)
	if save.get_len()!=0:
		var dict = save.get_var()
		post_process = dict["post_process"]
		fps = dict["fps"]
		music = dict["music"]
		sfx = dict["sfx"]
		unlocked = dict["unlocked_lvls"]

func _process(delta):
	Engine.target_fps = fps
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), -50 + (music)/2)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), -50 + (sfx)/2)

func _notification(what):
	if what==NOTIFICATION_EXIT_TREE:
		var data = {"fps": fps, "post_process": post_process, "music": music, "sfx": sfx, "unlocked_lvls":unlocked}
		var save_data = File.new()
		save_data.open("user://data.save", File.WRITE)
		save_data.store_var(data)
		save_data.close()
