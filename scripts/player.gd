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
onready var velocitytween = $VelocityTween
onready var animation = $AnimationPlayer
onready var kick_area = $KickArea
var hits = 0
var impact = false
var duck = false
var can_move = true
var dash_direction = Vector2.ZERO
var roll_direction = Vector2.ZERO
var hitline_to_mouse = Vector2.ZERO
var cards = [true, true, true]
var parry_direction = Vector2.ZERO
var enabled_moves = [true, true, true, true]
var dashed = false
var type = ""

signal roll_or_dash

func _input(event):
	if event.is_action_pressed("attack") and is_on_floor():
			attack()
	
	if event.is_action_pressed("dash") and can_move and dash_direction==Vector2.ZERO and FUEL>=10 and roll_direction==Vector2.ZERO and enabled_moves[2]:
			dash_direction = hitline.cast_to*5
			dash()
			FUEL-=10
	if event.is_action_pressed("roll") and can_move and roll_direction==Vector2.ZERO and dash_direction==Vector2.ZERO and is_on_floor() and enabled_moves[3]:
			roll_direction.x = hitline.cast_to.x*3.5
			dash()
		
	if Input.is_action_pressed("card1"):
			if cards[0] == true:
				FUEL = 170
				cards[0] = false
			
	if Input.is_action_pressed("card2"):
			if cards[1] == true:
				effect.emitting = true
				for i in safezone.get_overlapping_bodies():
					if i is Damagable and !i == self:
						i.emit_signal("damage_received", 999, Vector2.ZERO)
				cards[1] = false
			
	if Input.is_action_pressed("card3"):
			if cards[2] == true:
				hits = -5

func _physics_process(delta):
	JUMPING = false
	if !impact:
		VELOCITY = Vector2(0, VELOCITY.y)
		if Input.is_action_pressed("ui_left"):
			VELOCITY.x = -90
			
		if Input.is_action_pressed("ui_right"):
			VELOCITY.x = 90
			
		if Input.is_action_pressed("ui_up") and after_jump == 0:
			jump()
			
		if Input.is_action_pressed("parry") and is_on_floor() and !duck and enabled_moves[0]:
			parry_direction = hitline.cast_to
			can_move = false
		elif Input.is_action_just_released("parry"):
			parry_direction = Vector2.ZERO
			can_move = true
		
		if Input.is_action_pressed("ui_down") and is_on_floor() and parry_direction==Vector2.ZERO and enabled_moves[1]:
			duck = true
		else:
			duck = false
			
		if !JUMPING:
			if !is_on_floor():
				VELOCITY.y = lerp(VELOCITY.y, 300, 0.1)
			else:
				VELOCITY.y = 0
	
		if VELOCITY.x>0:
			hitline.cast_to.x = 75
		elif VELOCITY.x<0:
			hitline.cast_to.x = -75
	if impact:
		move_and_slide(VELOCITY, Vector2.UP)
	elif dash_direction!=Vector2.ZERO:
		move_and_slide(dash_direction, Vector2.UP)
	elif roll_direction!=Vector2.ZERO:
		roll_direction.y = VELOCITY.y
		move_and_slide(roll_direction, Vector2.UP)
	elif !duck:
		move_and_slide(VELOCITY, Vector2.UP)
	elif can_move:
		move_and_slide(Vector2(VELOCITY.x/4, VELOCITY.y), Vector2.UP)



func handle_iframes():
	for i in range(8):
		sprite.visible = !sprite.visible
		iframetimer.start()
		yield(iframetimer, "timeout")
		iframe-=1
	can_move = true


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
	connect("roll_or_dash", self, "dash_or_roll")

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
	if iframe==0:
		if ((parry_direction.x*-1==vector.x*75) or (vector!=Vector2.DOWN and duck) or (roll_direction!=Vector2.ZERO)):
			if parry_direction.x*-1==vector.x*75:
				enabled_moves[0] = false
				if enabled_moves.count(false)>=3:
					enabled_moves = [true, true, true, true]
				parry_direction = Vector2.ZERO
				can_move = true
				after_attack("parry")
				VELOCITY.x = vector.x*400
			elif duck:
				enabled_moves[1] = false
				if enabled_moves.count(false)>=3:
					enabled_moves = [true, true, true, true]
				duck = false
				can_move = true
				after_attack("duck")
			
		else:
			current_hitpoints -= damage
			hits=0
			for i in range(0, enabled_moves.size()):
				enabled_moves[i] = true
			if current_hitpoints<0:
				print("YOU LOSE!")
			else:
				iframe = 8
				handle_iframes()
				velocitytween.interpolate_property(self, "VELOCITY", Vector2.ZERO,
				vector*150+Vector2(0, -5), 0.25, Tween.TRANS_CIRC,Tween.EASE_OUT)
				velocitytween.interpolate_property(self, "after_jump", 0, 0, 1)
				impact = true
				velocitytween.start()
				yield(velocitytween, "tween_all_completed")
				impact = false
				
func attack():
	var target = hitline.get_collider()
	var attacks = enabled_moves.count(false)
	if target is Damagable and attacks==2:
		var dmg = 1
		if type == "parry":
			dmg+=2
		elif type == "duck":
			for i in kick_area.get_overlapping_bodies():
				if i is Damagable and not i==self:
					i.emit_signal("damage_received", dmg, Vector2.ZERO) 
		elif type == "dash":
			var proj = load("res://objects/Projectile.tscn").instance()
			proj.harmful_to_player = false
			proj.velocity = Vector2(hitline.cast_to.x/10, 0)
			proj.global_position = global_position-Vector2(0, 10)
			proj.sprite = load("res://graphics/images/shockwave.png")
			proj.should_emit = true
			proj.particle_transform = Transform2D(Vector2(2, 0), Vector2(0, 5), Vector2(0,0))
			print(hitline.cast_to.x==-75)
			if hitline.cast_to.x==-75:
				proj.invert_image = true
			get_tree().get_root().get_node("Node2D").add_child(proj)
		target.emit_signal("damage_received", dmg, Vector2(hitline.cast_to.x*4, -300))
		heal(2)
		for i in range(0, enabled_moves.size()):
			enabled_moves[i] = true

func dash():
	print("Dashed!")
	dashtimer.start()
	yield(dashtimer, "timeout")
	dash_direction = Vector2.ZERO
	roll_direction = Vector2.ZERO
	dashed = false
	
func dash_or_roll():
	if dash_direction!=Vector2.ZERO:
		dashed = true
		enabled_moves[2] = false
		if enabled_moves.count(false)>=3:
			enabled_moves = [true, true, true, true]
		after_attack("dash")
	elif roll_direction!=Vector2.ZERO:
		dashed = true
		enabled_moves[3] = false
		if enabled_moves.count(false)>=3:
			enabled_moves = [true, true, true, true]
		after_attack("roll")

func _process(delta):
	var dir
	if hitline.cast_to.x>0:
		dir = "Right"
	else:
		dir = "Left"
	if JUMPING or dash_direction!=Vector2.ZERO:
		animation.play("Jump"+dir)
	else:
		if is_on_floor():
			if duck:
				animation.play("Duck"+dir)
			elif parry_direction!=Vector2.ZERO:
				animation.play("Parry"+dir)
			elif roll_direction!=Vector2.ZERO:
				animation.play("Roll")
			elif VELOCITY==Vector2.ZERO:
				animation.play("Idle"+dir)
			elif VELOCITY!=Vector2.ZERO:
				animation.play("Walk"+dir)
		
		else:
			animation.play("Fall"+dir)
			
func after_attack(atk):
	var num = 0
	for i in enabled_moves:
		if i:
			num+=1
	if num==2:
		type = atk
		
