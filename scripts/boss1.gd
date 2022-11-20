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
onready var destroyer = $Destroyer
onready var point = sprite.get_node("Position2D")
onready var line = destroyer.get_node("Line2D")
export var laughing = false
export var ai := false
export var projectile_spawner_position := Vector2.ZERO
export(Array, NodePath) var laser_paths
export(PoolVector2Array) var spawner_positions
export(PoolVector2Array) var destroyer_positions
var last_attack = 0
var to_superpower = 6
var projectile = preload("res://objects/Projectile.tscn")
var bomb = preload("res://objects/bomb.tscn")
var base_enemy = preload("res://objects/base_enemy.tscn")
var pool = 0

func enter_arena():
	for i in range(5):
		sprite.position.y-=145.2
		enter_timer.start()
		yield(enter_timer, "timeout")
	laughing = true

func _ready():
	enter_arena()

func start_spawner():
	randomize()
	
	spawner_timer.start()
	yield(spawner_timer, "timeout")
	if pool!=2:
		pool+=1
		var pos = spawner_positions[0]
		var inst = base_enemy.instance()
		inst.global_position = pos
		inst.player_path = player_path
		inst.max_hitpoints = 4
		inst.connect("killed", self, "decrease")
		print(inst.is_connected("killed", self, "decrease"))
		get_tree().get_root().get_node("Node2D").add_child(inst)
	start_spawner()
	
func choose_attack():
	randomize()
	attack_timer.start()
	yield(attack_timer, "timeout")
	var attack = randi() % 3 + 1
	while attack==last_attack:
		attack = randi() % 3 + 1
	
	match attack:
		1:
			spawn_projectile()
		2:
			laser_spawn()
		3:
			bomb_spawn()
		_:
			pass
	last_attack = attack
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
		inst.global_position = player.position-Vector2(0, 600)
		get_tree().get_root().get_node("Node2D").add_child(inst)
		bomb_timer.start()
		yield(bomb_timer, "timeout")

func _process(delta):
	line.points = [destroyer.position, point.position]
	print(pool)
	if laughing and !ai:
		animation.play("Laugh")
	elif !laughing and ai:
		position.x = lerp(position.x, player.position.x, 0.01)

func decrease():
	pool-=1
	if pool<0:
		pool = 0
