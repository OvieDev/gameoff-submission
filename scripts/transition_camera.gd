extends Camera2D
class_name TransitionCamera

export var static_position := Vector2.ZERO

var new_zoom = zoom

signal transition(from)

func emit_transition():
	emit_signal("transition", self)

func transition(from):
	zoom = from.zoom
	from.current = false
	current = true
	global_position = from.global_position
	
func _process(delta):
	print(global_position)
	zoom = lerp(zoom, new_zoom, 0.1)
	if static_position==Vector2.ZERO:
		position = lerp(position, Vector2.ZERO, 0.1)
	else:
		global_position = lerp(global_position, static_position, 0.1)

func _on_transition(from):
	if current:
		return
	transition(from)
