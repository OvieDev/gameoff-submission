extends Area2D

onready var timer = $Timer
onready var particles = $Particles2D
onready var sprite = $Sprite

export var level_unlocking := 0
export var level := "res://scenes/mainmenu.tscn"

func _on_body_entered(body):
	if body is Player:
		body.get_node("AudioStreamPlayer2D").playing = false
		$AudioStreamPlayer2D.play()
		GameManager.unlocked[level_unlocking] = true
		sprite.frame = 1
		body.ai = false
		particles.emitting = true
		timer.start()
		yield(timer,"timeout")
		get_parent().restart(level)
