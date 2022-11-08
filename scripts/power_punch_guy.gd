extends Enemy
onready var particles = $JetPackEffect
onready var to_floor = $ToFloor
onready var target_raycast = $Target
var boosting = true
var able_to_boost_again = 0
var must_boost = false

func _process(delta):
	._process(delta)
	if last_dir==false:
		particles.position = Vector2(-15, 11)
	else:
		particles.position = Vector2(13, 11)
	particles.emitting = boosting

func ai():
	dist = position.distance_to(player.position)
	direction_to_player = position.direction_to(player.position)
	
	target_raycast.cast_to = position.direction_to(player.position)*200
	if !impact:
		rotation = lerp(rotation, 0, 0.1)
		if to_floor.is_colliding() or (is_on_wall() and direction_to_player.y<0):
			boosting = true
		
		if is_on_ceiling():
			boosting = false
	
		must_boost = position.y>player.position.y
		
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
		move_and_slide(velocity, Vector2.UP)
	
		last_dir = velocity.x<0
	
		if !boosting and able_to_boost_again>0:
			able_to_boost_again-=1
			if able_to_boost_again==0:
				boosting = true
	
func anim_and_attack():
	var dir = ""
	if last_dir:
		dir = "Left"
	else:
		dir = "Right"
	if !impact:
		if attack_tick==0:
			animation.play("Walk"+dir)
		else:
			animation.play("Punch"+dir)
	else:
		animation.play("Fall"+dir)
		rotate(deg2rad(5))
		
	if target_raycast.get_collider() is Player and dist<150 and attack_tick==0 and cooldown_tick==0:
		attack_tick = 120
		
	if attack_tick>0:
		attack_tick-=1
		if attack_tick==1:
			cooldown_tick = 180
	
	if cooldown_tick>0:
		cooldown_tick-=1
		
func end_jump():
	impact = false
