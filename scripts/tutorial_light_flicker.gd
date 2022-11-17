extends Light2D
onready var tween = $Tween

func _ready():
	tweening()

func tweening():
	randomize()
	tween.interpolate_property(self, "energy", energy, rand_range(0.05, 0.3), 0.1)
	tween.start()
	yield(tween, "tween_all_completed")
	tweening()
