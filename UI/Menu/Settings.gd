
# Scene with an OptionButton to select the resolution from a list of options
extends Popup

onready var escapeMenu = load("res://UI/Menu/EscapeMenu.tscn")
# We store a reference to the OptionButton to get the selected option later

onready var popup = $"."
onready var volMaster = $TabContainer/Audio/HSliderMaster
onready var volMusic = $TabContainer/Audio/HSliderMusic
onready var volSound = $TabContainer/Audio/HSliderSound

onready var display = $TabContainer/Video/OptionButtonVideo

func _ready():
	display.select(0 if Settings.game_data.fullscreen_on else 1)
	GlobalSettings.toggle_fullscreen(Settings.game_data.fullscreen_on)
	volMaster.value = Settings.game_data.master_vol
	volMusic.value = Settings.game_data.music_vol
	volSound.value = Settings.game_data.sound_vol
	




func _on_OptionButtonVideo_toggled(button_pressed):
	if button_pressed==true:
		theme = load("res://UI/Menu/SettingsDOWN.tres")
	else:
		theme = load("res://UI/Menu/Settings.tres")



func _on_OptionButtonVideo_item_selected(index):
	GlobalSettings.toggle_fullscreen(true if index == 0 else false)


func _on_HSliderMaster_value_changed(value):
	GlobalSettings.update_master_vol(value)
	if value == -50:
			AudioServer.set_bus_mute(0,true)
	else:
		AudioServer.set_bus_mute(0,false)
		
func _on_HSliderMusic_value_changed(value):
	GlobalSettings.update_music_vol(value)
	if value == -50:
		AudioServer.set_bus_mute(1,true)
	else:
		AudioServer.set_bus_mute(1,false)

func _on_HSliderSound_value_changed(value):
	GlobalSettings.update_sound_vol(value)
	if value == -50:
		AudioServer.set_bus_mute(2,true)
	else:
		AudioServer.set_bus_mute(2,false)



func _on_TextureButtonQuit_pressed():
	var startMenu = get_tree().get_root().get_node_or_null("StartMenu")
	
	
	
	PlayerData.settings = false
	popup.hide()
	
	if startMenu != null:
		get_tree().get_root().get_node("StartMenu" + "/Menu").hide()
	else:
		get_tree().get_root().get_node(PlayerData.player_data["Player"]["World"] + "/CanvasLayer/Menu").hide()
	get_tree().paused = false


	
