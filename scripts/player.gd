extends KinematicBody2D
class_name Player

var VELOCITY = Vector2.ZERO
var JUMPING = false

func _physics_process(delta):
	print(VELOCITY)
	VELOCITY = Vector2(0, VELOCITY.y)
	
	if Input.is_action_pressed("ui_left"):
		VELOCITY.x = -150
		
	if Input.is_action_pressed("ui_right"):
		VELOCITY.x = 150
		
	if Input.is_action_pressed("ui_up") and is_on_floor():
		JUMPING = true
		
	if !JUMPING:
		if !is_on_floor():
			VELOCITY.y = lerp(VELOCITY.y, 300, 0.2)
		else:
			VELOCITY.y = 0
	else:
		VELOCITY.y = lerp(VELOCITY.y, -300, 0.25)
		
		if VELOCITY.y > -300 and VELOCITY.y < -295:
			JUMPING = false
	move_and_slide(VELOCITY, Vector2.UP)
