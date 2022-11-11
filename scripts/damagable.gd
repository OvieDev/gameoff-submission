extends KinematicBody2D
class_name Damagable

export var max_hitpoints := 10
export var speed := 75
var current_hitpoints = max_hitpoints
var iframe = 0

signal damage_received(damage, vector, unparryable, frombullet)

func die():
	pass

func heal(amount):
	current_hitpoints+=amount
	if current_hitpoints>max_hitpoints:
		current_hitpoints = max_hitpoints
