extends Area2D
class_name HealthPack

export var heal_amount := 3
export var possible_positions := PoolVector2Array([])
export var cooldown := 10
var real_cooldown = cooldown*60

func _on_health_pack_pickup(body):
	if body is Player:
		body.heal(heal_amount)
		set_deferred("monitoring", false)
		real_cooldown = cooldown*60
		print("Collided!")

func _process(delta):
	if monitoring==false:
		real_cooldown-=1
		if real_cooldown==0:
			set_deferred("monitoring", true)
			randomize()
			global_position = possible_positions[randi() % possible_positions.size()]
			
