extends "res://scripts/destroyer.gd"
onready var timer = $Timer
onready var invader = $Invader

export var dropping = false

func timeout():
	timer.start()
	yield(timer, "timeout")
	randomize()
	var ncurrent = positions[randi() % positions.size()]
	while ncurrent==current:
		ncurrent = positions[randi() % positions.size()]
	current = ncurrent
	print(current)
	global_position = current
	dropping = true
	animation.play("Drop")
	yield(timer, "timeout")
	dropping = true
	animation.play("Pickup")
	yield(timer, "timeout")
	timeout()
	
func _ready():
	timeout()
	
func processing():
	if !dropping:
		.processing()
	
func _on_self_dmg_received(damage, vector, unparryable, frombullet):
	._on_self_dmg_received(damage, vector, unparryable, frombullet)
	dropping = true
	animation.play("Pickup")
	timer.start()
