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


