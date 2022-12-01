extends Enemy
onready var particles = $JetPackEffect
onready var to_floor = $ToFloor
onready var target_raycast = $Target
var unique_id
var boosting = true
var able_to_boost_again = 0
var must_boost = false
var dashing = false
var dash_cooldown = 200

func _ready():
	unique_id = get_instance_id()
	player.connect("parried", self, "parry_response")

func _process(delta):
	._process(delta)
	if last_dir==false:
		particles.position = Vector2(-15, 11)
	else:
		particles.position = Vector2(13, 11)
	
	if dashing and last_dir:
		particles.rotation = deg2rad(-90)
	elif dashing and !last_dir:
		particles.rotation = deg2rad(90)
	else:
		particles.rotation = 0
	particles.emitting = boosting or dashing

func ai():
	print(impacttimer.is_stopped())
	dist = position.distance_to(player.position)
	direction_to_player = position.direction_to(player.position)
	
	
	target_raycast.cast_to = position.direction_to(player.position)*200
	if !impact:
		rotation = lerp(rotation, 0, 0.1)
		if to_floor.is_colliding() or is_on_floor() or (is_on_wall() and direction_to_player.y<0):
			boosting = true
		
		if is_on_ceiling():
			boosting = false
	
		must_boost = position.y>player.position.y
		
		if round(dist)>400 and !dashing and !(left_ray.is_colliding() and right_ray.is_colliding() or is_on_wall()) and global_position.y-100>player.global_position.y:
			jump()
		
		if boosting:
			velocity+=Vector2(0, -10)
		else:
			velocity+=Vector2(0, 10)
			if velocity.y>100:
				velocity = Vector2(0, 100)
		if velocity.y<-200 and !must_boost:
			able_to_boost_again = 120
			boosting = false
		elif velocity.y<-150 and must_boost:
			velocity.y = -150
		
		velocity.x = direction_to_player.x*50
		
		if dashing:
			velocity.x = 200 if !last_dir else -200
			velocity.y = 0
		move_and_slide(velocity, Vector2.UP)
	
		last_dir = velocity.x<0
	
		if !boosting and able_to_boost_again>0:
			able_to_boost_again-=1
			if able_to_boost_again==0:
				boosting = true
	
func anim_and_attack(delta):
	print(attack_tick)
	print(cooldown_tick)
	var dir = ""
	if last_dir:
		dir = "Left"
	else:
		dir = "Right"
	if dashing:
		animation.play("Fall"+dir)
	elif !impact:
		if attack_tick<=0:
			animation.play("Walk"+dir)
		else:
			animation.play("Punch"+dir)
	elif impact:
		animation.play("Fall"+dir)
		rotate(deg2rad(5))
	
		
	if target_raycast.get_collider() is Player and dist<150 and attack_tick<=0 and cooldown_tick<=0:
		attack_tick = 1.5
		
	if cooldown_tick>0:
		cooldown_tick-=delta
		return
		
	if attack_tick>0:
		attack_tick-=delta
		if attack_tick<=0:
			randomize()
			var bullet = load("res://objects/Projectile.tscn").instance()
			bullet.id = get_instance_id()
			bullet.parryable = true
			bullet.velocity = target_raycast.cast_to/50
			bullet.global_position = global_position
			bullet.should_emit = true
			bullet.sprite = load("res://graphics/images/light_ball.png")
			bullet.damage = 3
			get_tree().get_root().get_node("Node2D").add_child(bullet)
			cooldown_tick = 6
	
		
func end_jump():
	print("Ended!")
	impact = false
	if dashing and dist<400 or is_on_wall():
		dashing = false
		timer.stop()

func jump():
	dashing = true
	timer.start()
	
func parry_response(id):
	if id==get_instance_id():
		impact = true
		emit_signal("damage_received", 3, Vector2.ZERO, false, null)
