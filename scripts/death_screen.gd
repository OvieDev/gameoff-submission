extends Control

onready var tween = $Tween
onready var button = $Button
func _on_player_death():
	$AudioStreamPlayer.playing = true
	tween.interpolate_property(self, "modulate", Color(1,1,1,0), Color(1,1,1,1), 0.75, Tween.TRANS_LINEAR, Tween.EASE_OUT, 1)
	tween.interpolate_property($AudioStreamPlayer, "volume_db", -72, 0, 0.75)
	tween.start()
	yield(tween,"tween_all_completed")
	button.grab_focus()


func _on_Yes_pressed():
	$AudioStreamPlayer.playing = false
	var m = AudioServer.get_bus_index("Music")
	var s = AudioServer.get_bus_index("SFX")
	get_parent().get_parent().get_node("Node2D").restart(get_tree().current_scene.filename)


func _on_No_pressed():
	$AudioStreamPlayer.playing = false
	get_parent().get_parent().get_node("Node2D").restart("res://scenes/mainmenu.tscn")
