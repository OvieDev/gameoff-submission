extends Particles2D
onready var timer = $Timer
onready var circle = $Particles2D
export var timescale = 1.0

func _ready():
	speed_scale = timescale
	circle.speed_scale = timescale
	emitting = true
	circle.emitting = true
	timer.start()
	yield(timer, "timeout")
	queue_free()
