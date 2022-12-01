extends "res://scripts/destroyer.gd"
onready var timer = $Timer
onready var invader = $Invader
export var up = true

export var dropping = false

func timeout():
	timer.start()
	yield(timer, "timeout")
	_play_anim()
	timer.start()
	yield(timer, "timeout")
	_play_anim()
	timeout()
	
func _ready():
	timeout()
	
	
func processing():
	print(animation.current_animation)
	if !up:
		.processing()
		collision_layer = 4
	else:
		collision_layer = 0
	
func _on_self_dmg_received(damage, vector, unparryable, frombullet):
	._on_self_dmg_received(damage, vector, unparryable, frombullet)
	dropping = true
	modulate = Color(1,0,0,1)
	animation.play("Pickup")
	timer.start()
	up = true

func _play_anim():
	modulate = Color(1,1,1,1)
	if up:
		randomize()
		var ncurrent = positions[randi() % positions.size()]
		while ncurrent==current:
			ncurrent = positions[randi() % positions.size()]
		current = ncurrent
		global_position = current
		animation.play("Drop")
	else:
		animation.play("Pickup")
		up = true
