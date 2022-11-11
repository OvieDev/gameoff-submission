extends Area2D
class_name HealthPack

export var heal_amount := 3
export var possible_positions := PoolVector2Array([])
export var cooldown := 10
onready var sprite = $AnimatedSprite
onready var tween = $Tween
onready var particles = $Particles2D

func _on_health_pack_pickup(body):
	if body is Player:
		body.heal(heal_amount)
		set_deferred("monitoring", false)
		sprite.modulate = Color(1,1,1,0.2)
		move_to_new_position()
		particles.emitting = true
			
func move_to_new_position():
	randomize()
	var pos = possible_positions[randi() % possible_positions.size()]
	
	tween.interpolate_property(self, "global_position", global_position, pos, 
	cooldown, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
	
	yield(tween, "tween_all_completed")
	
	set_deferred("monitoring", true)
	sprite.modulate = Color(1,1,1,1)
	
