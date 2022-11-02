extends Damagable
class_name Enemy
export var player_path : NodePath
onready var player = get_node(player_path)
onready var left_ray = $Left
onready var right_ray = $Right
onready var timer = $Timer
onready var impacttimer = $ImpactTimer
var direction_to_player = Vector2.ZERO
var ignore = false
var jumping = false
var impact = false
var velocity = Vector2(direction_to_player.x, 0)

func _ready():
	timer.connect("timeout", self, "end_jump")
	impacttimer.connect("timeout", self, "end_jump")

func _physics_process(delta):
	ignore = false
	if !impact:
		if round(direction_to_player.y)<0:
			if !left_ray.is_colliding() and !right_ray.is_colliding():
				get_direction()
				jump()
		if !ignore:
			get_direction()
		velocity = lerp(velocity, Vector2(direction_to_player.x, velocity.y), 0.075)
	if !jumping:
		if is_on_floor():
			velocity.y = 0
		else:
			velocity.y = 300
	if left_ray.get_collider() or right_ray.get_collider():
		jump()
	move_and_slide(velocity, Vector2.UP)

func get_direction():
	var mul
	if jumping:
		mul = 1.5
	else:
		mul = 1
	direction_to_player = position.direction_to(player.position)
	if direction_to_player.x<-0.1:
		direction_to_player.x = -100*mul
	elif direction_to_player.x>0.1:
		direction_to_player.x = 100*mul
	else:
		direction_to_player.x = 0

func jump():
	var dist = position.distance_to(player.position)
	if is_on_floor() and dist<200 and dist>100 and !player.JUMPING:
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


func _on_Enemy_damage_received(damage, vector):
	current_hitpoints-=damage
	if current_hitpoints<=0:
		queue_free()
	else:
		jumping = false
		impact = true
		velocity = vector
		impacttimer.start()


func _on_Area2D_body_entered(body):
	if body is Player:
		body.emit_signal("damage_received", 1, Vector2.ZERO)
