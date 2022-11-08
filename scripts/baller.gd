extends Enemy
class_name Baller
onready var projectile = $Projectile
onready var tween = $Tween
var has_ball = true

func get_direction():
	.get_direction()
	if !has_ball and attack_tick==0:
		collision_layer = 4
		collision_mask = 1
		direction_to_player.x = -direction_to_player.x
	else:
		collision_layer = 12
		collision_mask = 9

func _on_Damagable_damage_received(damage, vector, unparryable):
	print("damaged")
	current_hitpoints-=damage
	if current_hitpoints<=0:
		queue_free()
	else:
		jumping = false
		impact = true
		velocity = vector
		impacttimer.start() # Replace with function body.

func anim_and_attack():
	var dir
	if last_dir==false:
		dir = "Left"
	else:
		dir = "Right"
	
	if attack_tick!=0:
		animation.play("Throw"+dir)
		last_dir = last_dir
	else:
		if impact:
			animation.play("Attacked"+dir)
		else:
			if is_on_wall():
				animation.play("Idle"+dir)
			else:
				animation.play("Walk"+dir)
	
	
	if cooldown_tick==0:
		if attack_tick==0:
			if left_ray.get_collider() is Player and has_ball:
				attack_tick = 60
				cooldown_tick = 600
				has_ball = false
			elif right_ray.get_collider() is Player and has_ball:
				attack_tick = 60
				cooldown_tick = 600
				has_ball = false
		
	else:
		cooldown_tick-=1
		if attack_tick!=0:
			attack_tick-=1
		if cooldown_tick<=30:
			projectile.visible = true
			tween.interpolate_property(projectile, "modulate", Color(1,1,1,0), Color(1,1,1,1),
			0.1, Tween.TRANS_CUBIC, Tween.EASE_OUT)
			tween.interpolate_property(projectile.get_material(), "shader_param/white",
			1, 0, 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
			tween.start()
			has_ball = true

func spawn_projectile():
	var proj = load("res://objects/Projectile.tscn")
	var bullet = proj.instance()
	bullet.global_position = global_position
	bullet.velocity = Vector2(direction_to_player.x/10, 0)
	bullet.rotate = 2.5
	get_tree().get_root().get_node("Node2D").add_child(bullet)
	
func _on_DashRegion_body_entered(body):
		if body is Player:
			if (body.dash_direction!=Vector2.ZERO or body.roll_direction!=Vector2.ZERO) and !body.dashed: # Replace with function body.
				body.emit_signal("roll_or_dash")
