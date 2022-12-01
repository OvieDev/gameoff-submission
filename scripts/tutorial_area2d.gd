extends Area2D
var used = true


func _on_Area2D_body_entered(body):
	if body is Player and used:
		body.enabled_moves = [false, false, true, true]
		body.gui.emit_signal("used_ability", 0)
		body.gui.emit_signal("used_ability", 1)
		used = false
