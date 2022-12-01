extends Button
class_name LevelButton

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var lvl := 0


# Called when the node enters the scene tree for the first time.
func _ready():
	if !GameManager.unlocked[lvl]:
		disabled = true
