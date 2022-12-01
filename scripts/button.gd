extends Area2D
class_name AreaButton

var should_be_active = true

onready var sprite = $Sprite
onready var timer = $Timer
onready var next_node_obj = get_node(next_node) if next_node!="" else null
onready var light = $Light2D

export(NodePath) var next_node
export var active := true
export var method := ""
export var group := ""

signal activate_next
signal stop_previous
signal failed
signal finish_loop

func _ready():
	print(next_node_obj)
	connect("activate_next", self, "activate_next")
	timer.connect("timeout", self, "timer_timeout")
	if next_node_obj:
		next_node_obj.connect("stop_previous", self.timer, "stop")
	if active:
		sprite.frame = 1
		light.energy = 1
	
func _process(delta):
	monitoring = active

func _body_entered(body):
	print(self)
	if body is Player and active and next_node_obj!=null and should_be_active:
		active = false
		sprite.frame = 2
		emit_signal("stop_previous")
		next_node_obj.emit_signal("activate_next")
		timer.start()
		light.energy = 1
		$Activater.play()
	elif body is Player and active and not next_node_obj and should_be_active:
		for i in get_tree().get_nodes_in_group(group):
			i.call(method)
		emit_signal("finish_loop")
		emit_signal("stop_previous")
		should_be_active = false
		sprite.frame = 0
		light.energy = 0
		$Activater.play()

func timer_timeout():
	print("Timeout!")
	if get_signal_connection_list("failed").size()==0:
		active = true
		sprite.frame = 1
	else:
		emit_signal("failed")
		sprite.frame = 0 
		light.energy = 0
		active = false
	$Deactivater.play()
		
		
func activate_next():
	light.energy = 1
	sprite.frame = 1
	active = true
	
func finish_loop():
	print(self)
	should_be_active = false
	emit_signal("finish_loop")
	sprite.frame = 0
	light.energy = 0
