extends KinematicBody2D
class_name Damagable

export var max_hitpoints := 10
export var speed := 75
export var ai := true
var current_hitpoints
var explosion = preload("res://objects/death_explosion.tscn")
var iframe = 0
signal damage_received(damage, vector, unparryable, frombullet)

func _ready():
	current_hitpoints = max_hitpoints

func die():
	var inst = explosion.instance()
	inst.global_position = global_position
	get_tree().get_root().get_node("Node2D").add_child(inst)
	queue_free()

func heal(amount):
	current_hitpoints+=amount
	if current_hitpoints>max_hitpoints:
		current_hitpoints = max_hitpoints
		
func deal_damage(damage):
	current_hitpoints-=damage
	if current_hitpoints<=0:
		die()
