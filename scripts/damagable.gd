extends KinematicBody2D
class_name Damagable

export var max_hitpoints := 10
export var speed := 75
var current_hitpoints = max_hitpoints
var iframe = 0
var explosion = preload("res://objects/death_explosion.tscn")

signal damage_received(damage, vector, unparryable, frombullet)

func die():
	var inst = explosion.instance()
	inst.global_position = global_position
	get_tree().get_root().get_node("Node2D").add_child(inst)
	queue_free()

func heal(amount):
	current_hitpoints+=amount
	if current_hitpoints>max_hitpoints:
		current_hitpoints = max_hitpoints
