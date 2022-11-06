extends KinematicBody2D
class_name Projectile
export var sprite : Texture
export var velocity := Vector2(1,0)
export var damage := 1
onready var sprite_node = $Sprite

func _ready():
	sprite_node.texture = sprite

func _physics_process(delta):
	sprite_node.rotate(deg2rad(2.5))
	var collision = move_and_collide(velocity)
	if collision:
		if collision.collider is Player:
			if collision.collider.roll_direction==Vector2.ZERO and !collision.collider.duck:
				queue_free()
				collision.collider.emit_signal("damage_received", damage, velocity/5)
			elif collision.collider.duck:
				collision_mask = 1
				collision.collider.emit_signal("damage_received", damage, velocity/5)
			else:
				collision_mask = 1
				collision.collider.emit_signal("roll_or_dash")
		else:
			queue_free()

				

