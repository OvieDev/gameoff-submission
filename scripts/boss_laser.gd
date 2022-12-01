extends Area2D

signal shoot_laser
onready var timer = $Timer
onready var tween = $Tween
onready var color_rect = $ColorRect
var deadly = false
func _ready():
	connect("shoot_laser", self, "laser")
	
func laser():
	var mat = color_rect.get_material()
	mat.set_shader_param("visible", true)
	mat.set_shader_param("alpha", 0)
	mat.set_shader_param("phase", true)
	timer.start()
	yield(timer, "timeout")
	mat.set_shader_param("phase", false)
	deadly = true
	tween.interpolate_property(mat, "shader_param/width", 0.5, 10, 0.5)
	tween.interpolate_property(mat, "shader_param/alpha", 0, 1, 0.6)
	tween.start()
	yield(tween, "tween_step")
	deadly = false
	
func _process(delta):
	if deadly:
		for i in get_overlapping_bodies():
			if i is Player:
				i.deal_damage(99)


func _on_Boss_death():
	queue_free()
