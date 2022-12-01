extends Node2D
class_name Level

export var level_name := "Level name"
onready var enter_rect = $Enter/ColorRect
onready var enter_label = $Enter/Label
onready var tween = $Enter/Tween

func _ready():
	var m = AudioServer.get_bus_index("Music")
	var s = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_mute(m, false)
	AudioServer.set_bus_mute(s, false)
	GameManager.current_level = level_name
	Gui.visible = true
	Gui.get_node("Control").modulate = Color(1,1,1,1)
	PauseMenu.can_be_paused = true
	DeathScreen.visible = false
	DeathScreen.get_node("Control").modulate = Color(1,1,1,0)
	Engine.time_scale = 1
	if !GameManager.post_process:
		remove_child(get_node("WorldEnvironment"))
	enter_label.text = level_name
	tween.interpolate_property(enter_rect.get_material(), "shader_param/circle_size", 0, 1, 1.5)
	tween.interpolate_property(enter_label, "modulate", Color(1,1,1,1), Color(1,1,1,0), 2, Tween.TRANS_LINEAR, Tween.EASE_IN, 1)
	tween.start()

func restart(scene):
	tween.interpolate_property(enter_rect.get_material(), "shader_param/circle_size", 1, 0, 0.75)
	tween.start()
	yield(tween,"tween_all_completed")
	if scene == "":
		get_tree().reload_current_scene()
	else:
		get_tree().change_scene(scene)
