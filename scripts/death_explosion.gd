extends Particles2D
onready var timer = $Timer
onready var circle = $Particles2D


func _ready():
	emitting = true
	circle.emitting = true
	timer.start()
	yield(timer, "timeout")
	queue_free()
