extends StaticBody2D
onready var tween = $Tween
export var times_to_destroy := 1
var closed = false

func _on_Damagable_killed():
	times_to_destroy-=1
	if times_to_destroy<=0:
		tween.interpolate_property(self, "modulate", Color(1,1,1,1), Color(1,1,1,0), 0.5)
		tween.start()
		yield(tween, "tween_all_completed")
		queue_free()
		
func close_door():
	if !closed:
		collision_layer = 1
		collision_mask = 1
		tween.interpolate_property(self, "modulate", Color(1,1,1,0), Color(1,1,1,1), 0.5)
		tween.start()
		closed = true
