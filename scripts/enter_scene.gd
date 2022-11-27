extends UIFreeScene

onready var label = $Label
onready var timer = $Timer
onready var audio = $AudioStreamPlayer
onready var transition = $TransitionPlayer

func _ready():
	label.visible = false
	timer.start()
	yield(timer, "timeout")
	label.visible = true
	audio.playing = true
	yield(audio,"finished")
	timer.start()
	yield(timer, "timeout")
	for i in range(5):
		transition.playing = true
		label.modulate -= Color(0,0,0,0.2)
		yield(transition,"finished")
		transition.pitch_scale -= 0.2
	label.modulate = Color(1,1,1,0)
	get_tree().change_scene("res://scenes/mainmenu.tscn")
	
