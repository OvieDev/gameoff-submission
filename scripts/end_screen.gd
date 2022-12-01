extends UIFreeScene
onready var tween = $Tween
onready var overlay = $ColorRect2
onready var label = $ColorRect/Label2
func _ready():
	tween.interpolate_property(overlay, "modulate", Color(1,1,1,1), Color(1,1,1,0), 2)
	tween.start()
	yield(tween, "tween_all_completed")
	tween.interpolate_property(label, "modulate", Color(1,1,1,0), Color(1,1,1,1), 0.5)
	tween.start()
	yield(tween, "tween_all_completed")
	tween.interpolate_property(overlay, "modulate", Color(1,1,1,0), Color(1,1,1,1), 2, Tween.TRANS_LINEAR, Tween.EASE_IN, 1)
	tween.start()
	yield(tween, "tween_all_completed")
	get_tree().change_scene("res://scenes/mainmenu.tscn")
