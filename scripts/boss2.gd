extends KinematicBody2D
class_name BossUfo
export(NodePath) var player_path

onready var player = get_node(player_path)
onready var sprite = $Ufo
onready var animation = $AnimationPlayer
onready var timer = $Timer
onready var laser_timer = $LaserTimer
onready var death_ray_timer = $DeathRayTween
onready var tween = $Tween
onready var laser = $Laser
onready var laser_rect = $Laser/ColorRect
onready var particles = $Laser/Particles2D
onready var death_circ = $DeathRay
onready var death_rect = $DeathRay/ColorRect
onready var death_ray_timer_real = $DeathRayTimer
onready var initial_y = global_position.y
onready var spawner_timer = $SpawnerTimer
export var ai := false
export var bash_start := Vector2(0,0)
export var bash_end := Vector2(0,0)
export var spawner_position := Vector2(0,0)

var last_attack = 0
var collision
var laser_enabled = false
var bomb = preload("res://objects/bomb.tscn")
var move_ray = true
var to_bash = 4
var bashing = false
var last_position = Vector2.ZERO
var enemy = preload("res://objects/base_enemy.tscn")
var pool = []
var death = false

signal bash_ended
signal after_bash
signal anim_finished

func _process(delta):
	if death:
		Engine.time_scale = lerp(Engine.time_scale, 1, 0.005)
		return
	if !ai:
		return
	if bashing:
		sprite.rotation_degrees = lerp(sprite.rotation_degrees, -22.5, 0.1)
		collision = move_and_collide(Vector2.LEFT*10)
		if collision:
			if collision.collider is Damagable and !collision.collider is Player:

				collision.collider.emit_signal("damage_received", 8, Vector2.LEFT, false, null)
			elif collision.collider is Player:
				collision_layer = 0
				collision_mask = 0
				collision.collider.emit_signal("damage_received", 8, Vector2.LEFT, false, null)
		if global_position.x<bash_end.x:
			emit_signal("after_bash")
		return
	if collision or position.direction_to(player.position).x<0.1 and position.direction_to(player.position).x>-0.1 or !move_ray:
		sprite.rotation_degrees = lerp(sprite.rotation_degrees, 0, 0.1)
	elif position.direction_to(player.position).x>0:
		sprite.rotation_degrees = lerp(sprite.rotation_degrees, 22.5, 0.1)
	elif position.direction_to(player.position).x<0:
		sprite.rotation_degrees = lerp(sprite.rotation_degrees, -22.5, 0.1)
	if ai and move_ray:
		death_circ.global_position = lerp(death_circ.global_position, player.global_position, 0.01)
		move_and_collide(Vector2(position.direction_to(player.position).x*10, 0))
	if laser_enabled:
		for i in laser.get_overlapping_bodies():
			if i is Player:
				i.emit_signal("damage_received", 4, Vector2.DOWN, false, null)
	global_position.y = lerp(global_position.y, initial_y, 0.1)

func _ready():
	connect("after_bash", self, "after_bash")
	connect("anim_finished", self, "AnimationPlayer_animation_finished")
	#enter_arena()
	#choose_attack()
	#activate_spawner()
	
func activate_spawner():
	spawner_timer.start()
	yield(spawner_timer, "timeout")
	if pool.size()<4:
		var inst = enemy.instance()
		inst.max_hitpoints = 12
		inst.global_position = spawner_position
		inst.player_path = player_path
		pool.append(inst)
		inst.connect("killed", self, "_remove_enemy", [inst])
		get_tree().get_root().get_node("Node2D").add_child(inst)
	activate_spawner()

func enter_arena():
	animation.play("EnterArena")
	
func choose_attack():
	timer.start()
	yield(timer, "timeout")
	if to_bash>0:
		randomize()
		var attack = randi() % 3 + 1
		while attack==last_attack:
			attack = randi() % 3 + 1 
		match attack:
			1:
				spawn_bombs()
			2:
				spawn_laser()
			3: 
				spawn_death_ray()
			_:
				pass
		last_attack = attack
		to_bash -= 1
	else:
		bash()
		yield(self, "bash_ended")
	choose_attack() 

func spawn_bombs():
	for i in range(3):
		var inst = bomb.instance()
		inst.modulate = Color(1,1,1,0)
		inst.global_position = global_position + Vector2(-100+(i*100), 200)
		get_tree().get_root().get_node("Node2D").add_child(inst)
		tween.interpolate_property(inst, "modulate", Color(1,1,1,0), Color(1,1,1,1), 0.25)
	tween.start()

func spawn_laser():
	laser_rect.get_material().set_shader_param("phase", true)
	laser_rect.get_material().set_shader_param("visible", true)
	laser_rect.get_material().set_shader_param("alpha", 0)
	laser_timer.start()
	yield(laser_timer, "timeout")
	particles.emitting = true
	laser_rect.get_material().set_shader_param("phase", false)
	laser_timer.start()
	laser_enabled = true
	yield(laser_timer, "timeout")
	laser_enabled = false
	particles.emitting = false
	tween.interpolate_property(laser_rect.get_material(), "shader_param/alpha", 0, 1, 0.2)
	tween.start()

func stop_enter():
	print("finished")
	animation.stop()
	ai = true
	sprite.position = Vector2(0,0)
	death_rect.get_material().set_shader_param("opacity", 0.3)
	
func spawn_death_ray():
	death_ray_timer.interpolate_property(death_rect.get_material(), "shader_param/opacity", 0.3, 0.7, 0.5)
	death_ray_timer.start()
	move_ray = false
	yield(death_ray_timer,"tween_all_completed")
	death_rect.get_material().set_shader_param("opacity", 1)
	death_ray_timer.interpolate_property(death_rect.get_material(), "shader_param/circ_radius", 0, 0.48, 0.2)
	death_ray_timer.start()
	yield(death_ray_timer,"tween_all_completed")
	for i in death_circ.get_overlapping_bodies():
		if i is Player:
			i.deal_damage(6)
	death_ray_timer_real.start()
	yield(death_ray_timer_real, "timeout")
	death_rect.get_material().set_shader_param("opacity", 0.3)
	move_ray = true

func bash():
	last_position = global_position
	death_rect.get_material().set_shader_param("opacity", 0)
	animation.play("BashEnter")
	
func after_bash():
	collision_layer = 1
	collision_mask = 1
	global_position = last_position-Vector2(0,500)
	bashing = false
	to_bash = 4
	death_rect.get_material().set_shader_param("opacity", 0.3)
	emit_signal("bash_ended")
	


func AnimationPlayer_animation_finished():
	print("FINISHED DA WOT")
	bashing = true
	animation.stop()
	sprite.position = Vector2.ZERO
	global_position = bash_start


func _on_Destroyer_destroy():
	ai = false
	var expl = load("res://objects/death_explosion.tscn").instance()
	expl.global_position = sprite.global_position
	expl.scale = Vector2(25, 25)
	Engine.time_scale = 0.2
	get_tree().get_root().get_node("Node2D").add_child(expl) # Replace with function body.
	for i in pool:
		i.deal_damage(999)
	pool.clear()
	animation.play("Death")
	sprite.z_index = -1
	death = true
	
func _notification(what):
	if what==NOTIFICATION_EXIT_TREE:
		Engine.time_scale = 1
	
func _remove_enemy(which):
	pool.erase(which)
