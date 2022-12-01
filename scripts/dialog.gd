extends Label
export(Array, String, MULTILINE) var texts := []

var accept_input = false
var ptr = 0
var done = false

export(NodePath) var plr_path

func dialog():
	print("dialog!")
	get_parent().get_parent().visible = true
	if done:
		return
	done = true
	accept_input = true

	
func _input(event):
	if !accept_input:
		return
	if event.is_action_pressed("ui_accept"):
		ptr += 1
		if ptr>=texts.size():
			get_node(plr_path).ai = true
func _process(delta):
	if ptr>=texts.size():
		get_parent().visible = false
		accept_input = false
		return
	text = texts[ptr]
