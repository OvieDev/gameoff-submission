extends Control

onready var progress = $Fuel
onready var health = $Health
onready var combo = $Combo
onready var combo_tween = $Combo/Tween
var charge = preload("res://graphics/images/supercharged_health_bar.tres")
onready var abilities = [$Parry, $Duck, $Dash, $Roll, $Supercharge, $Shield, $BonusAttack]
signal toggle_supercharge
signal used_ability(id)
signal refill
signal combo_changed(value)

func _ready():
	connect("toggle_supercharge", self, "supercharge")
	connect("used_ability", self, "ability")
	connect("refill", self, "fill")
	connect("combo_changed", self, "combo")
	
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

func combo(value):
	combo.text = "Combo: x"+str(value)
	combo_tween.interpolate_property(combo, "rect_scale", Vector2(2,2), Vector2(1,1), 0.5,Tween.TRANS_SINE, Tween.EASE_OUT)
	combo_tween.start()
