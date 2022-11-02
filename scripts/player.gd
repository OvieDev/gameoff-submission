extends Damagable
class_name Player

var VELOCITY = Vector2.ZERO
var JUMPING = false
var FUEL = 75
var after_jump = 0
onready var timer = $Timer
onready var sprite = $Sprite
var hits = 0

func _physics_process(delta):
	print(JUMPING)
	print(FUEL)
	JUMPING = false
	VELOCITY = Vector2(0, VELOCITY.y)
	
	if Input.is_action_pressed("ui_left"):
		VELOCITY.x = -150
		
	if Input.is_action_pressed("ui_right"):
		VELOCITY.x = 150
		
	if Input.is_action_pressed("ui_up") and after_jump == 0:
		jump()
		
	if !JUMPING:
		if !is_on_floor():
			VELOCITY.y = lerp(VELOCITY.y, 300, 0.2)
		else:
			VELOCITY.y = 0
	move_and_slide(VELOCITY, Vector2.UP)




func jump():
	if FUEL!=0:
		JUMPING = true
		VELOCITY.y = lerp(VELOCITY.y, -300, 0.1)
		FUEL-=1
		if FUEL==0:
			after_jump = 10
	else:
		JUMPING = false
		
func _ready():
	timer.connect("timeout", self, "add_fuel")
	timer.start()

func add_fuel():
	if !JUMPING and FUEL!=75:
		if after_jump<=1:
			FUEL+=1
			if FUEL>10:
				after_jump = 0	
		else:
			after_jump-=1
	timer.start()


func _on_KinematicBody2D_damage_received(damage):
	current_hitpoints -= damage
	hits+=1
	if hits>3:
		hits = 0
	if current_hitpoints<0:
		print("YOU LOSE!")
