extends Projectile
var caster
export var lifetime := 120
onready var area = $Area2D

func physics():
	sprite_node.rotate(deg2rad(rotate))
	var collision = move_and_collide(velocity)
	if collision and !destroying:
		if collision.collider is Player and harmful_to_player:
			if collision.collider.roll_direction==Vector2.ZERO and !collision.collider.parry_direction==Vector2.ZERO:
				queue_free()
				collision.collider.emit_signal("damage_received", damage, velocity/5)
			elif collision.collider.parry_direction:
				caster.emit_signal("damage_received", damage, Vector2.ZERO)
			else:
				collision_mask = 1
				collision.collider.emit_signal("roll_or_dash")
		elif collision.collider is Enemy and !harmful_to_player and !hits.has(collision.collider):
			collision.collider.emit_signal("damage_received", damage, impact)
			hits.append(collision.collider)
		else:
			end_of_life()
	lifetime-=1
	if lifetime==0:
		for i in area.get_overlapping_bodies():
			if i is Player:
				i.emit_signal("damage_received", damage, velocity/5)
		queue_free()

