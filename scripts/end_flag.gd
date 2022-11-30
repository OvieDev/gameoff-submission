extends Area2D

onready var timer = $Timer
onready var particles = $Particles2D
onready var sprite = $Sprite

func _on_body_entered(body):
	if body is Player:
		sprite.frame = 1
		body.ai = false
		particles.emitting = true
		timer.start()
		yield(timer,"timeout")
		get_parent().restart("res://scenes/mainmenu.tscn")
