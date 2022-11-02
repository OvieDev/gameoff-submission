extends Damagable
class_name Enemy
export var player_path : NodePath
onready var player = get_node(player_path)
onready var left_ray = $Left
onready var right_ray = $Right
onready var timer = $Timer
var direction_to_player = Vector2.ZERO
var ignore = false
var jumping = false
var velocity = Vector2(direction_to_player.x, 0)

func _ready():
	timer.connect("timeout", self, "end_jump")

func _physics_process(delta):
	ignore = false
	if round(direction_to_player.y)<0:
		if !left_ray.is_colliding() and !right_ray.is_colliding():
			print("my god it should work")
			get_direction()
			jump()
		
		elif left_ray.is_colliding() and right_ray.is_colliding():
			ignore = true
			get_direction()
			print(direction_to_player)
		
		#elif !left_ray.is_colliding():
		#	direction_to_player.x = -75
		#	ignore = true
		#elif !right_ray.is_colliding():
		#	direction_to_player.x = 75
		#	ignore = true
	if !ignore:
		get_direction()
	velocity = Vector2(direction_to_player.x, velocity.y)
	if !jumping:
		if is_on_floor():
			velocity.y = 0
		else:
			velocity.y = 300
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
	print("called")
	var dist = position.distance_to(player.position)
	if is_on_floor() and dist<200 and dist>100:
		left_ray.enabled = false 
		right_ray.enabled = false
		jumping = true
		velocity.y -= 700
		timer.start()
		
func end_jump():
	jumping = false
	left_ray.enabled = true 
	right_ray.enabled = true
