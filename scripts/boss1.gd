extends KinematicBody2D
class_name BossFactoryRobot

export(NodePath) var player_path
onready var player = get_node(player_path)
onready var sprite = $Sprite
onready var enter_timer = $EnterTimer
onready var attack_timer = $AttackTimer
onready var bomb_timer = $BombTimer
onready var spawner_timer = $SpawnerTimer
onready var animation = $AnimationPlayer
onready var particles = $Sprite/Particles2D
onready var tween = $Tween
onready var laser = $Sprite/Laser
export var laughing = false
export var ai := false
export var projectile_spawner_position := Vector2.ZERO
export(Array, NodePath) var laser_paths
export(PoolVector2Array) var spawner_positions
export(PoolVector2Array) var destroyer_positions
export(NodePath) var destroyer_path
onready var destroyer = get_node(destroyer_path)
var last_attack = 0
var to_superpower = 6
var projectile = preload("res://objects/Projectile.tscn")
var bomb = preload("res://objects/bomb.tscn")
var base_enemy = preload("res://objects/base_enemy.tscn")
var pool = 0
var dead = false
var look = true
var enemies = []
var entered = false

signal death

func enter_arena():
	if entered:
		return
	entered = true
	for i in range(5):
		sprite.position.y-=145.2
		enter_timer.start()
		yield(enter_timer, "timeout")
	laughing = true


func start_spawner():
	randomize()
	
	spawner_timer.start()
	yield(spawner_timer, "timeout")
	if pool!=2 and !dead:
		pool+=1
		var pos = spawner_positions[0]
		var inst = base_enemy.instance()
		inst.global_position = pos
		inst.player_path = player_path
		inst.max_hitpoints = 4
		inst.connect("killed", self, "decrease", [inst])
		enemies.append(inst)
		get_tree().get_root().get_node("Node2D").add_child(inst)
	start_spawner()
	
func choose_attack():
	randomize()
	attack_timer.start()
	yield(attack_timer, "timeout")
	if dead:
		return
		
	if to_superpower>0:
		var attack = randi() % 6 + 1
		while attack==last_attack:
			attack = randi() % 6 + 1
	
		match attack:
			1,2,6:
				spawn_projectile()
			3:
				laser_spawn()
			4,5:
				bomb_spawn()
			_:
				pass
		last_attack = attack
		to_superpower-=1
	else:
		superattack()
		to_superpower = 6
	choose_attack()
	
func spawn_projectile():
	var inst = projectile.instance()
	inst.sprite = load("res://graphics/images/fist-o-rocket.png")
	inst.velocity = Vector2(-10, 0)
	inst.damage = 5
	inst.impact = Vector2(-2, 0)
	if player.position.y<-1400:
		inst.global_position = projectile_spawner_position-Vector2(0,250)
	else:
		inst.global_position = projectile_spawner_position
	inst.particle_transform = Transform2D(Vector2(4, 0), Vector2(0, 4), Vector2(0,0))
	get_tree().get_root().get_node("Node2D").add_child(inst)

func laser_spawn():
	for i in laser_paths:
		get_node(i).emit_signal("shoot_laser")

func bomb_spawn():
	for i in range(3):
		var inst = bomb.instance()
		connect("death", inst, "queue_free")
		inst.global_position = player.position-Vector2(0, 600)
		get_tree().get_root().get_node("Node2D").add_child(inst)
		bomb_timer.start()
		yield(bomb_timer, "timeout")

func _process(delta):
	if !dead:
		if look:
			laser.look_at(player.position)
		print(pool)
		if laughing and !ai:
			animation.play("Laugh")
		elif !laughing and ai:
			position.x = lerp(position.x, player.position.x, 0.01)
	else:
		animation.play("Death")
		Engine.time_scale = lerp(Engine.time_scale, 1, 0.005)
func decrease(inst):
	enemies.remove(enemies.find(inst))
	pool-=1
	if pool<0:
		pool = 0


func _on_Destroyer_destroy():
	emit_signal("death")
	dead = true
	for i in enemies:
		i.deal_damage(999)
	var expl = load("res://objects/death_explosion.tscn").instance()
	expl.global_position = sprite.global_position
	expl.scale = Vector2(25, 25)
	Engine.time_scale = 0.2
	get_tree().get_root().get_node("Node2D").add_child(expl)
	

func superattack():
	tween.interpolate_property(particles.process_material, "color", Color(1,1,1,0), Color(1,1,1,1), 1)
	tween.interpolate_property(particles, "speed_scale", 0, 1, 2,Tween.TRANS_EXPO, Tween.EASE_OUT)
	tween.start()
	laser.get_node("ColorRect").color = Color(1,0,0,0.2)
	particles.emitting = true
	yield(tween, "tween_completed")
	look = false
	yield(tween, "tween_all_completed")
	for i in laser.get_overlapping_bodies():
		if i is Damagable:
			i.deal_damage(999)
	tween.interpolate_property(laser.get_node("ColorRect"), "color", Color(1,1,1,1), Color(1,1,1,0), 0.5)
	tween.start()
	look = true
	
func _notification(what):
	if what==NOTIFICATION_EXIT_TREE:
		Engine.time_scale = 1
