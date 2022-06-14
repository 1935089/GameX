extends Control

onready var setting = $Menu
var username

func _ready():
	pass



func _on_StartButton_pressed():
# warning-ignore:return_value_discarded
	if PlayerData.player_data["Player"]["World"] != null:
		get_tree().change_scene("res://Game/"+ PlayerData.player_data["Player"]["World"]+".tscn")
	else:
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Game/Customization.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()


func _on_OptionsButton_pressed():
	setting.popup()


func _on_CreditsButton_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://UI/Menu/Credits.tscn")
