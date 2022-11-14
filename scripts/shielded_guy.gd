extends Enemy
class_name ShieldedGuy
onready var sprite = $Sprite
onready var tween = $Tween
onready var colorrect = $ColorRect
var targets = []
var tick = 200

func _process(delta):
	if velocity==Vector2.ZERO or !is_on_floor():
		sprite.rotation = lerp(sprite.rotation, 0, 0.025)
	elif last_dir==true:
		sprite.rotation = lerp(sprite.rotation, deg2rad(20), 0.1)
	elif last_dir==false:
		sprite.rotation = lerp(sprite.rotation, deg2rad(-20), 0.1)
	if tick==0:
		heal_or_protect(0, Vector2.ZERO, false, null)
		tick = 200
	tick -= 1

func _on_HealArea_body_entered(body):
	if !body in targets and body is Damagable and !body is Player and body!=self:
		targets.append(body)

func _on_HealArea_body_exited(body):
	if body in targets:
		targets.remove(targets.find(body))
		
func heal_or_protect(damage, vector, parryable, bullet):
	randomize()
	for i in targets:
		if randi() % 2 == 0:
			i.heal(5)
			tween.interpolate_property(i, "modulate", Color(1,0,0), Color(1,1,1), 0.5)
		else:
			i.shield = true
			tween.interpolate_property(i, "modulate", Color(0,0,1), Color(1,1,1), 0.5)
	tween.interpolate_property(colorrect.get_material(), "shader_param/size", 3, 1, 0.4, Tween.TRANS_CIRC)
	tween.interpolate_property(colorrect.get_material(), "shader_param/alpha", 0, 0.4, 0.5, Tween.TRANS_CIRC)
	tween.start()
	yield(tween, "tween_all_completed")
	tween.interpolate_property(colorrect.get_material(), "shader_param/alpha", 0.4, 0, 0.1, Tween.TRANS_QUINT)
	tween.start()
	
func anim_and_attack():
	var dir
	if last_dir==false:
		dir = "Left"
	else:
		dir = "Right"
	if attack_tick==0 and is_on_floor():
		if velocity==Vector2.ZERO or is_on_wall():
			animation.play("Idle"+dir)
		elif velocity!=Vector2.ZERO and is_on_floor():
			animation.play("Walk"+dir)
	elif attack_tick==0 and !is_on_floor():
		animation.play("Fall"+dir)
	else:
		animation.play("Punch"+dir)
	
	if cooldown_tick==0:
		if attack_tick==0:
			if left_ray.get_collider() is Player and position.distance_to(player.position)<60:
				attack_tick = 30
				attack_dir = true
			elif right_ray.get_collider() is Player and position.distance_to(player.position)<60:
				attack_tick = 30
				attack_dir = false
		else:
		
			if attack_dir and attack_tick==1:
				if left_ray.get_collider() is Player:
					left_ray.get_collider().emit_signal("damage_received", 1, Vector2(-1, 0), true, null)
					cooldown_tick = 60
			elif !attack_dir and attack_tick==1:
				if right_ray.get_collider() is Player:
					right_ray.get_collider().emit_signal("damage_received", 1, Vector2(1, 0), true, null)
					cooldown_tick = 60
			attack_tick-=1
	else:
		cooldown_tick-=1
		
