extends KinematicBody2D
class_name Projectile
export var sprite : Texture
export var velocity := Vector2(1,0)
export var damage := 1
export var harmful_to_player := true
export var impact := Vector2.ZERO
export var rotate := 0.0
export var should_emit := false
export var invert_image := false
onready var particle = $Particles2D
onready var sprite_node = $Sprite
onready var tween = $Tween
var destroying = false

func _ready():
	print(get_parent())
	sprite_node.texture = sprite
	if harmful_to_player:
		collision_mask = 3
	else:
		collision_mask = 9
	particle.emitting = should_emit
	particle.texture = sprite
	set_inversion()

func _physics_process(delta):
	sprite_node.rotate(deg2rad(rotate))
	var collision = move_and_collide(velocity)
	if collision and !destroying:
		if collision.collider is Player and harmful_to_player:
			if collision.collider.roll_direction==Vector2.ZERO and !collision.collider.duck:
				queue_free()
				collision.collider.emit_signal("damage_received", damage, velocity/5)
			elif collision.collider.duck:
				collision_mask = 1
				collision.collider.emit_signal("damage_received", damage, velocity/5)
			else:
				collision_mask = 1
				collision.collider.emit_signal("roll_or_dash")
		elif collision.collider is Enemy and !harmful_to_player:
			collision.collider.emit_signal("damage_received", damage, impact)
		else:
			end_of_life()

				
func set_inversion():
	if invert_image:
		sprite_node.scale.x = -1
		particle.process_material.angle = -180
		
func end_of_life():
	collision_mask = 1
	destroying = true
	tween.interpolate_property(self, "modulate", Color(1,1,1,1), Color(1,1,1,0), 0.2)
	tween.start()
	yield(tween, "tween_completed")
	print("completed")
	queue_free()
