extends Area2D



func _on_Killzone_body_entered(body):
	if body is Damagable:
		body.deal_damage(5)
		if body is Player:
			body.VELOCITY.y = -900
		else:
			body.velocity.y = -900
