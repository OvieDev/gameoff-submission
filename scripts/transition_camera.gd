extends Camera2D
class_name TransitionCamera

export(NodePath) var inbetween
export var static_position := Vector2.ZERO

var new_zoom = zoom

signal transition(from)

func transition(from):
	zoom = from.zoom
	
func _process(delta):
	zoom = lerp(zoom, new_zoom, 0.1)


func _on_transition(from):
	pass # Replace with function body.
