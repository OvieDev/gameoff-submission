extends Enemy
class_name ShieldedGuy
var targets = []


func _process(delta):
	randomize()
	if randi() % 360==0:
		heal_or_protect(0, Vector2.ZERO, false, null)

func _on_HealArea_body_entered(body):
	if body is Damagable and not body is Player:
		body.connect("damage_received", self, "heal_or_protect")
		targets.append(body)

func _on_HealArea_body_exited(body):
	if body in targets:
		if body.is_connected("damage_received", self, "heal_or_protect"):
			body.disconnect("damage_received", self, "heal_or_protect") # Replace with function body.
			targets.remove(targets.find(body))
		
func heal_or_protect(damage, vector, parryable, bullet):
	randomize()
	for i in targets:
		if randi() % 3==2:
			if randi() % 2 == 0:
				i.heal(1)
			else:
				i.shield = true
