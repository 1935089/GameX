extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var original_name

# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.get_name() == "Windows":
		if OS.has_environment("USERNAME"):
			PlayerData.player_data["Player"]["Username"] = OS.get_environment("USERNAME")[0].to_upper()+ OS.get_environment("USERNAME").substr(1,-1)

	else:
		if OS.has_environment("USER"):
			PlayerData.player_data["Player"]["Username"] = OS.get_environment("USER")[0].to_upper()+ OS.get_environment("USERNAME").substr(1,-1)
	
	original_name = PlayerData.player_data["Player"]["Username"]
	$Question.text = "Should I call you "+ original_name +" or do you want to change your name"


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Change_pressed():
	if $Name.text.length() >= 2:
		PlayerData.player_data["Player"]["Username"] = $Name.text
		$Error.visible = false
		$"Popup/Panel/Sure".text = "Are you sure you want to change your name to " + PlayerData.player_data["Player"]["Username"]
		$Popup.visible = true
	else:
		$Error.visible = true
	
func _on_Keep_pressed():
	PlayerData.player_data["Player"]["Username"] = original_name
	$"Popup/Panel/Sure".text = "Are you sure you want to keep the name " + PlayerData.player_data["Player"]["Username"]
	$Popup.visible = true

func _on_No_pressed():
	$Popup.visible = false


func _on_Yes_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Game/World.tscn")
	
	

func _on_Back_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://UI/Menu/StartMenu.tscn")
