extends KinematicBody2D
class_name Damagable

export var max_hitpoints := 10
export var speed := 75
export var ai := true
var current_hitpoints
var iframe = 0
var explosion = preload("res://objects/death_explosion.tscn")

signal damage_received(damage, vector, unparryable, frombullet)

func _ready():
	current_hitpoints = max_hitpoints

func die():
	var inst = explosion.instance()
	inst.global_position = global_position
	get_tree().get_root().get_node("Node2D").add_child(inst)
	queue_free()

func heal(amount):
	print(self)
	current_hitpoints+=amount
	print(current_hitpoints)
	print(max_hitpoints)
	if current_hitpoints>max_hitpoints:
		current_hitpoints = max_hitpoints
