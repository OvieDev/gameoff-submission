extends KinematicBody2D
class_name Projectile
export var sprite : Texture
export var velocity := Vector2(1,0)
export var damage := 1
export var harmful_to_player := true
onready var sprite_node = $Sprite

func _ready():
	sprite_node.texture = sprite
	if harmful_to_player:
		collision_mask = 3
	else:
		collision_mask = 9

func _physics_process(delta):
	sprite_node.rotate(deg2rad(2.5))
	var collision = move_and_collide(velocity)
	if collision:
		if collision.collider is Player and harmful_to_player:
			if collision.collider.roll_direction==Vector2.ZERO and !collision.collider.duck:
				queue_free()
				collision.collider.emit_signal("damage_received", damage, velocity/5)
			elif collision.collider.duck:
				collision_mask = 1
				collision.collider.emit_signal("damage_received", damage, velocity/5)
			else:
				collision_mask = 1
				collision.collider.emit_signal("roll_or_dash")
		elif collision.collider is Enemy and !harmful_to_player:
			collision.collider.emit_signal("damage_received", damage, velocity/5)
		else:
			queue_free()

				

