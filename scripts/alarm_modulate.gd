extends CanvasModulate

onready var tween = $Tween

func close_door():
	for i in range(10):
		tween.interpolate_property(self, "color", Color(1,0.2,0.2,1), Color(1,1,1,1), 2,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 1)
		tween.start()
		yield(tween,"tween_all_completed")

