extends Damagable
class_name Player

var VELOCITY = Vector2.ZERO
var JUMPING = false
var FUEL = 100
var after_jump = 0
onready var timer = $Timer
onready var iframetimer = $IframeTimer
onready var sprite = $Sprite
onready var hitline = $HitLine
onready var safezone = $Area2D
onready var effect = $SafezoneEffect
onready var dashtimer = $DashTimer
var hits = 0
var duck = false
var can_move = true
var dash_direction = Vector2.ZERO
var roll_direction = Vector2.ZERO
var hitline_to_mouse = Vector2.ZERO
var cards = [true, true, true]
var parry_direction = Vector2.ZERO

func _physics_process(delta):
	print(FUEL)
	JUMPING = false
	VELOCITY = Vector2(0, VELOCITY.y)
	
	if Input.is_action_pressed("ui_left"):
		VELOCITY.x = -150
		
	if Input.is_action_pressed("ui_right"):
		VELOCITY.x = 150
		
	if Input.is_action_pressed("ui_up") and after_jump == 0:
		jump()
		
	if Input.is_action_just_pressed("attack") and is_on_floor():
		attack()
		
	if Input.is_action_pressed("ui_down") and is_on_floor() and parry_direction==Vector2.ZERO:
		duck = true
	else:
		duck = false
		
	if Input.is_action_pressed("parry") and is_on_floor() and !duck:
		parry_direction = hitline.cast_to
		can_move = false
	elif Input.is_action_just_released("parry"):
		parry_direction = Vector2.ZERO
		can_move = true
	
	if Input.is_action_just_pressed("dash") and can_move and dash_direction==Vector2.ZERO and FUEL>=10 and roll_direction==Vector2.ZERO:
		dash_direction = hitline.cast_to*5
		dash()
		FUEL-=10
	if Input.is_action_just_pressed("roll") and can_move and roll_direction==Vector2.ZERO and dash_direction==Vector2.ZERO:
		roll_direction.x = hitline.cast_to.x*3
		dash()
		
	if Input.is_action_just_pressed("card1"):
		if cards[0] == true:
			FUEL = 170
			cards[0] = false
			
	if Input.is_action_just_pressed("card2"):
		if cards[1] == true:
			effect.emitting = true
			for i in safezone.get_overlapping_bodies():
				if i is Damagable and !i == self:
					i.emit_signal("damage_received", 999, Vector2.ZERO)
			cards[1] = false
			
	if Input.is_action_just_pressed("card3"):
		if cards[2] == true:
			hits = -5
		
	if !JUMPING:
		if !is_on_floor():
			VELOCITY.y = lerp(VELOCITY.y, 300, 0.2)
		else:
			VELOCITY.y = 0
	
	hitline_to_mouse = hitline.position.direction_to(get_local_mouse_position())
	if Input.is_action_just_pressed("look_right") or hitline_to_mouse.x>0:
		hitline.cast_to.x = 75
	elif Input.is_action_just_pressed("look_left") or hitline_to_mouse.x<0:
		hitline.cast_to.x = -75
	
	if dash_direction!=Vector2.ZERO:
		move_and_slide(dash_direction, Vector2.UP)
	elif roll_direction!=Vector2.ZERO:
		roll_direction.y = VELOCITY.y
		move_and_slide(roll_direction, Vector2.UP)
	elif can_move:
		move_and_slide(VELOCITY, Vector2.UP)



func handle_iframes():
	for i in range(8):
		print("iframed")
		sprite.visible = !sprite.visible
		iframetimer.start()
		yield(iframetimer, "timeout")
		iframe-=1


func jump():
	if FUEL!=0:
		JUMPING = true
		VELOCITY.y = lerp(VELOCITY.y, -300, 0.1)
		FUEL-=1
		if FUEL==0:
			after_jump = 2
	else:
		JUMPING = false
		
func _ready():
	timer.connect("timeout", self, "add_fuel")
	timer.start()
	emit_signal("damage_received", 1, Vector2.ZERO)
	emit_signal("damage_received", 1, Vector2.ZERO)

func add_fuel():
	if !JUMPING and FUEL<100:
		if after_jump<=1:
			FUEL+=1
			if FUEL>10:
				after_jump = 0	
		else:
			after_jump-=1
	timer.start()


func _on_KinematicBody2D_damage_received(damage, vector):
	if iframe==0 and (vector==Vector2.ZERO or parry_direction.x!=vector.x*75) or (vector==Vector2.DOWN and !duck):
		current_hitpoints -= damage
		hits+=1
		print(hits)
		if hits>=3:
			hits = 0
		if current_hitpoints<0:
			print("YOU LOSE!")
		else:
			iframe = 8
			handle_iframes()
			
func attack():
	var target = hitline.get_collider()
	if target is Damagable and (hits==2 or hits<0):
		target.emit_signal("damage_received", 1, Vector2(hitline.cast_to.x*4, -300))
		if (hits>=0):
			hits = 0
		else:
			hits+=1
		heal(2)

func dash():
	dashtimer.start()
	yield(dashtimer, "timeout")
	dash_direction = Vector2.ZERO
	roll_direction = Vector2.ZERO
