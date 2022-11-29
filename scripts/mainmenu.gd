extends UIFreeScene
onready var color_rect = $ColorRect
onready var tween = $Tween
onready var popup = $PopupPanel
onready var settings = $SettingsPanel
onready var vals = [$SettingsPanel/HSlider, $SettingsPanel/HSlider2, $SettingsPanel/CheckButton, $SettingsPanel/HSlider3]
onready var play_button = $Button
onready var music = $AudioStreamPlayer
func _ready():
	tween.interpolate_property(color_rect.get_material(), "shader_param/circle_size", 0, 1, 0.75, Tween.TRANS_SINE, Tween.EASE_IN, 0.5)
	tween.interpolate_property(music, "volume_db", -80, 0, 0.25)
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
	print(vals[0].value)
	if vals[0].value==0:
		GameManager.fps = 30
	elif vals[0].value==1:
		GameManager.fps = 60
	elif vals[0].value==2:
		GameManager.fps = 120
	elif vals[0].value == 3:
		GameManager.fps = 0
	vals[0].get_node("Label").text = str(GameManager.fps) if GameManager.fps!=0 else "inf."
	vals[1].get_node("Label").text = str(GameManager.music)
	vals[3].get_node("Label").text = str(GameManager.sfx)
	GameManager.music = vals[1].value
	GameManager.sfx = vals[3].value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), GameManager.sfx-100)


func _on_Settings_pressed():
	settings.visible = true
	vals[0].grab_focus()


func _on_Quit_pressed():
	get_tree().quit(0)
