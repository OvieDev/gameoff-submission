extends CanvasLayer
onready var pause_label = $Control/Label
onready var tween = $Control/Tween
onready var label = $Control/Label2
onready var font = pause_label.get("custom_fonts/font")

var current_selection = false
var can_be_paused = true

func _input(event):
	if event.is_action_pressed("ui_cancel") and can_be_paused:
		get_tree().paused = !get_tree().paused
		visible = !visible

func _ready():
	visible = false


func _on_Continue_pressed():
	get_tree().paused = !get_tree().paused
	visible = !visible

func _process(delta):
	label.text = "Level: "+GameManager.current_level+"\nCombo: x"+str(GameManager.combo)


func _on_MainMenu_pressed():
	get_parent().get_node("Node2D").restart("res://scenes/mainmenu.tscn")
