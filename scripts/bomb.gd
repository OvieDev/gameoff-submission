extends Damagable

onready var area = $Area2D
var velocity = Vector2.DOWN
var rot = 5

func _process(delta):
	rotate(deg2rad(rot))
	velocity = lerp(velocity, Vector2(0, 70), 0.005)
	var collision = move_and_collide(velocity)
	if collision:
		die()
		
func _ready():
	randomize()
	if randi()%2==0:
		rot = -5
	rotation_degrees = rand_range(-180, 180)

func die():
	for i in area.get_overlapping_bodies():
		if i is Player and i!=self:
			i.deal_damage(3)
	.die()
