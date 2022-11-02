extends KinematicBody2D
class_name Damagable

export var max_hitpoints := 10
var current_hitpoints = max_hitpoints

signal damage_received

func die():
	pass

func heal(amount):
	current_hitpoints+=amount
	if current_hitpoints>max_hitpoints:
		current_hitpoints = max_hitpoints
