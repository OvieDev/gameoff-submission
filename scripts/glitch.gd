extends CanvasLayer

onready var tween = $Tween
onready var colorrect = $ColorRect.get_material()
onready var modulate = $CanvasModulate
var used = false

func glitch():
	if used:
		return
	used = true
	tween.interpolate_property(colorrect, "shader_param/radius", 0, 1, 0.75, Tween.TRANS_CIRC)
	tween.interpolate_property(modulate, "color", Color.white, Color.aqua, 0.5, Tween.TRANS_CIRC)
	tween.start()
	yield(tween, "tween_all_completed")
	tween.interpolate_property(modulate, "color", Color.aqua, Color.white, 0.5, Tween.TRANS_CIRC)
	tween.start()
