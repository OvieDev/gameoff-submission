extends Enemy
onready var particles = $JetPackEffect
onready var to_floor = $ToFloor
var boosting = true
var able_to_boost_again = 0

func _process(delta):
	._process(delta)
	if last_dir==true:
		particles.position = Vector2(-15, 11)
	else:
		particles.position = Vector2(13, 11)
	particles.emitting = boosting

func ai():
	print(able_to_boost_again)
	dist = position.distance_to(player.position)
	direction_to_player = position.direction_to(player.position)
	
	if to_floor.is_colliding():
		boosting = true
	
	if dist>1000 and direction_to_player.y<0:
		boosting = true
	
	if is_on_ceiling():
		boosting = false
		
	if boosting:
		velocity+=Vector2(0, -10)
	else:
		velocity+=Vector2(0, 10)
		if velocity.y>100:
			velocity = Vector2(0, 100)
	if velocity.y<-200 and dist>1000 and direction_to_player.y<0:
		boosting = true
	elif velocity.y<-200:
		able_to_boost_again = 120
		boosting = false
	
	velocity.x = lerp(velocity.x, round(direction_to_player.x)*75, 0.8)
	
	move_and_slide(velocity, Vector2.UP)
	
	if !boosting and able_to_boost_again>0:
		able_to_boost_again-=1
		if able_to_boost_again==0:
			boosting = true
	
