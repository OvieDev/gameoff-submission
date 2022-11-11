extends Enemy
class_name Sniper
onready var aimer = $Aimer
onready var target = $Aimer/RayCast2D
onready var aim_direction = $Aimer/ColorRect
onready var tween = $Tween
var sniping = false

func _process(delta):
	if attack_tick>30 or attack_tick==0:
		aimer.look_at(player.position)
	

func anim_and_attack():
	var dir
	if attack_tick==0:
		if last_dir==false:
			dir = "Left"
		else:
			dir = "Right"
		if velocity==Vector2.ZERO or is_on_wall():
			animation.play("Idle"+dir)
		else:
			animation.play("Walk"+dir)
	
	if cooldown_tick==0:
		if attack_tick==0:
			if target.is_colliding():
				attack_tick = 60
		else:
			
			if attack_tick==1 and !sniping:
				sniping = true
				snipe()
			elif attack_tick!=1 and !sniping:
				aim_direction.get_material().set_shader_param("visible", true)
				aim_direction.get_material().set_shader_param("phase", true)
				aim_direction.get_material().set_shader_param("alpha", 0)
				attack_tick-=1
	else:
		cooldown_tick-=1
		
func snipe():
	aim_direction.get_material().set_shader_param("phase", false)
	tween.interpolate_property(aim_direction.get_material(), "shader_param/width", 0.5, 10, 0.25)
	tween.interpolate_property(aim_direction.get_material(), "shader_param/alpha", 0, 1, 0.4)
	tween.start()
	if target.get_collider():
		target.get_collider().emit_signal("damage_received", 2, Vector2.ZERO, false, null)
	yield(tween,"tween_all_completed")
	aim_direction.get_material().set_shader_param("visible", false)
	aim_direction.get_material().set_shader_param("alpha", 0)
	attack_tick = 0
	cooldown_tick = 400
	sniping = false
