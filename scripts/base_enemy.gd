extends Damagable
class_name Enemy
export var player_path : NodePath
onready var player = get_node(player_path)
onready var left_ray = $Left
onready var right_ray = $Right
onready var timer = $Timer
onready var impacttimer = $ImpactTimer
onready var animation = $AnimationPlayer
var direction_to_player = Vector2.ZERO
var ignore = false
var jumping = false
var impact = false
var velocity = Vector2(direction_to_player.x, 0)
var attack_tick = 0
var cooldown_tick = 0
var dist
var last_dir
var attack_dir = null 
var shield = false# null is none, true is left, false is right

signal killed

func _ready():
	timer.connect("timeout", self, "end_jump")
	impacttimer.connect("timeout", self, "end_jump")

func _physics_process(delta):
	if ai:
		ai()

func ai():
	dist = position.distance_to(player.position)
	ignore = false
	collision_layer = 12
	collision_mask = 9
	if !impact or attack_tick!=0:
		if round(direction_to_player.y)<0:
			if is_on_wall():
				get_direction()
				jump()
		if !ignore:
			get_direction()
			velocity = lerp(velocity, Vector2(direction_to_player.x, velocity.y), 0.075)
	else:
		collision_layer = 4
		collision_mask = 1
	if !jumping:
		if is_on_floor():
			velocity.y = 0
			velocity.y = lerp(velocity.y, 300, 0.1)
		else:
			velocity.y = lerp(velocity.y, 300, 0.1)
	if dist<=40 and !impact:
		velocity.x = 0
	if left_ray.get_collider() or right_ray.get_collider() and attack_tick==0:
		jump()
	if velocity.x>0:
		last_dir = true
	elif velocity.x<0:
		last_dir = false
	move_and_slide(velocity, Vector2.UP)

func get_direction():
	var mul
	if jumping:
		mul = 1.5
	else:
		mul = 1
	direction_to_player = position.direction_to(player.position)
	if direction_to_player.x<-0.1:
		direction_to_player.x = -speed*mul
		last_dir = false
	elif direction_to_player.x>0.1:
		direction_to_player.x = speed*mul
		last_dir = true
	else:
		direction_to_player.x = 0

func jump():
	
	if is_on_floor() and !player.JUMPING and dist>150:
		left_ray.enabled = false 
		right_ray.enabled = false
		jumping = true
		velocity.y -= 700
		timer.start()
		
func end_jump():
	jumping = false
	impact = false
	left_ray.enabled = true 
	right_ray.enabled = true


func _on_Enemy_damage_received(damage, vector, unparryable, id):
	if !shield:
		print("damaged")
		current_hitpoints-=damage
		attack_tick = 0
		cooldown_tick = 60
		if current_hitpoints<=0:
			die()
			emit_signal("killed")
		else:
			jumping = false
			impact = true
			velocity = vector
			impacttimer.start()
	else:
		shield = false

func _process(delta):
	if ai:
		anim_and_attack()


func _on_DashRegion_body_entered(body):

	if body is Player:
		if (body.dash_direction!=Vector2.ZERO or body.roll_direction!=Vector2.ZERO) and attack_tick!=0 and !body.dashed: # Replace with function body.
			body.emit_signal("roll_or_dash")

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
	else:
		if attack_dir==true:
			dir = "Left"
		else:
			dir = "Right"
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
		

