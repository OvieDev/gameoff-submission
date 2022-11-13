extends TextureRect
class_name ToggleableTexture
export var texture_displayed : Texture

signal toggle_texture
signal refill

func _ready():
	connect("toggle_texture", self, "toggle")
	connect("refill", self, "fill")
	texture = texture_displayed

func toggle():
	if modulate.v==0.5:
		modulate.v = 1
	else:
		modulate.v = 0.5
		
func fill():
	modulate.v = 1
