extends UIFreeScene
onready var color_rect = $ColorRect
onready var tween = $Tween
onready var popup = $PopupPanel
func _ready():
	tween.interpolate_property(color_rect.get_material(), "shader_param/circle_size", 0, 1, 0.75, Tween.TRANS_SINE, Tween.EASE_IN, 0.5)
	tween.start()
	grab_focus()


func _on_Play_pressed():
	popup.visible = true


func _on_CloseLevels_pressed():
	popup.visible = false
