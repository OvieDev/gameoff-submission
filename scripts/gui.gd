extends Control

onready var progress = $Fuel
onready var health = $Health
var charge = preload("res://graphics/images/supercharged_health_bar.tres")
onready var abilities = [$Parry, $Duck, $Dash, $Roll, $Supercharge, $Shield, $BonusAttack]
signal toggle_supercharge
signal used_ability(id)
signal refill

func _ready():
	connect("toggle_supercharge", self, "supercharge")
	connect("used_ability", self, "ability")
	connect("refill", self, "fill")
	
func supercharge():
	if !progress.texture_over:
		progress.texture_over = charge
	else:
		progress.texture_over = null
		
func ability(id):
	abilities[id].emit_signal("toggle_texture")
	
func fill():
	abilities[0].emit_signal("refill")
	abilities[1].emit_signal("refill")
	abilities[2].emit_signal("refill")
	abilities[3].emit_signal("refill")
