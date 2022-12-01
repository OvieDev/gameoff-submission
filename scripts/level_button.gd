extends Button
class_name LevelButton

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var lvl := 0
export var path := ""

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", self, "button_pressed")
	if !GameManager.unlocked[lvl]:
		disabled = true

func button_pressed():
	GameManager.selected = path
