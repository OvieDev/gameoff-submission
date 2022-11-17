extends Area2D
class_name Notifier
export var group := ""
export var method := ""


func _ready():
	connect("body_entered", self, "body_entered")
	
func body_entered(body):
	print("called")
	if body is Player:
		for i in get_tree().get_nodes_in_group(group):
			print(i)
			if method!="":
				i.call(method)
			else:
				i.ai = true
