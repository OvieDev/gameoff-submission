extends UIFreeScene
onready var color_rect = $ColorRect
onready var tween = $Tween
onready var popup = $PopupPanel
onready var settings = $SettingsPanel
onready var vals = [$SettingsPanel/HSlider, $SettingsPanel/HSlider2, $SettingsPanel/CheckButton, $SettingsPanel/HSlider3]
onready var play_button = $Button
onready var music = $AudioStreamPlayer
func _ready():
	tween.interpolate_property(color_rect.get_material(), "shader_param/circle_size", 0, 1, 1.5, Tween.TRANS_SINE, Tween.EASE_IN, 0.5)
	tween.interpolate_property(music, "volume_db", -80, 0, 0.001)
	tween.start()
	play_button.grab_focus()
	music.playing = true
	vals[0].value = GameManager.fps
	vals[1].value = GameManager.music
	vals[2].pressed = GameManager.post_process
	vals[3].value = GameManager.sfx


func _on_Play_pressed():
	play_button.release_focus()
	popup.visible = true
	popup.get_node("Button").grab_focus()


func _on_CloseLevels_pressed():
	popup.visible = false
	settings.visible = false
	play_button.grab_focus()

func _process(delta):
	print(GameManager.fps)
	vals[0].get_node("Label").text = str(GameManager.fps) if GameManager.fps!=0 else "inf."
	vals[1].get_node("Label").text = str(GameManager.music)
	vals[3].get_node("Label").text = str(GameManager.sfx)
	GameManager.music = vals[1].value
	GameManager.sfx = vals[3].value


func _on_Settings_pressed():
	settings.visible = true
	vals[0].grab_focus()


func _on_Quit_pressed():
	get_tree().quit(0)


func _on_FPS_value_changed(value):
	if value==0:
		GameManager.fps = 30
	elif value==1:
		GameManager.fps = 60
	elif value==2:
		GameManager.fps = 120
	elif value == 3:
		GameManager.fps = 0 # Replace with function body.


func _on_otherplay_pressed():
	tween.interpolate_property(color_rect.get_material(), "shader_param/circle_size", 1, 0, 1.5)
	tween.start()
	yield(tween,"tween_all_completed")
	get_tree().change_scene(GameManager.selected)
