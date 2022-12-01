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
export var particle_transform = Transform2D(Vector2(5, 0), Vector2(0, 5), Vector2(0,0))
export var parryable := false
onready var particle = $Particles2D
onready var sprite_node = $Sprite
onready var tween = $Tween
onready var area = $Area2D
var destroying = false
var hits = []
var id

func _ready():
	sprite_node.texture = sprite
	if harmful_to_player:
		area.collision_mask = 2
	else:
		area.collision_mask = 8
	particle.emitting = should_emit
	particle.texture = sprite
	set_shader_params()

func _physics_process(delta):
	physics()
			
func physics():
	sprite_node.rotate(deg2rad(rotate))
	var collision = move_and_collide(velocity)

	if impact == Vector2.ZERO:
		impact = Vector2(1 if velocity.x>0 else -1, 0)
	
	if collision and !destroying:
		end_of_life()
	
func set_shader_params():
	sprite_node.transform = particle_transform
	if invert_image:
		particle.process_material.set_shader_param("initial_angle", 180)
		sprite_node.scale.x = -1
	particle.process_material.set_shader_param("transform", particle_transform)
	
func end_of_life():
	destroying = true
	tween.interpolate_property(self, "modulate", Color(1,1,1,1), Color(1,1,1,0), 0.2)
	tween.start()
	yield(tween, "tween_completed")
	queue_free()


func _on_Target_body_entered(body):
	if destroying:
		return
	if body is Player and harmful_to_player:
		if body.roll_direction==Vector2.ZERO and !body.duck:
			print("player dmg")
			end_of_life()
			body.emit_signal("damage_received", damage, impact, parryable, id)
		elif body.duck:
			print("duck")
			area.collision_mask = 0
			body.emit_signal("damage_received", damage, impact, parryable, id)
		else:
			print("dash")
			area.collision_mask = 0
			body.emit_signal("roll_or_dash")

	elif body is Enemy and !harmful_to_player and !hits.has(body):
			print("enemy")
			body.emit_signal("damage_received", damage, impact, false, null)
			hits.append(body)
