extends AnimatedSprite
onready var label = $Label
export var ai = false
export(String, MULTILINE) var text := """Sample Text"""

func _ready():
	label.text = text

func _process(delta):
	label.visible = ai	
