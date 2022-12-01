extends Damagable

export(PoolVector2Array) var positions
var current
onready var animation = $AnimationPlayer

signal destroy

func _process(delta):
	processing()
	
func processing():
	global_position = lerp(global_position, current, 0.1)
	if iframe>0:
		iframe-=1
	animation.play("Rotate")
func _on_self_dmg_received(damage, vector, unparryable, frombullet):
	if iframe==0:
		randomize()
		current_hitpoints-=1
		var ncurrent = positions[randi() % positions.size()]
		while ncurrent==current:
			ncurrent = positions[randi() % positions.size()]
		current = ncurrent
		if current_hitpoints<=0:
			die()
			emit_signal("destroy")
		iframe = 600

func _ready():
	current = global_position
