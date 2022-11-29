extends Control

onready var tween = $Tween
onready var button = $Button
func _on_player_death():
	tween.interpolate_property(self, "modulate", Color(1,1,1,0), Color(1,1,1,1), 0.75, Tween.TRANS_LINEAR, Tween.EASE_OUT, 1)
	tween.start()
	yield(tween,"tween_all_completed")
	button.grab_focus()
