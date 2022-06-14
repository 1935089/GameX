extends Popup



onready var music = $Music
# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:return_value_discarded
	Music.connect("showMusic", self, "music_changed")
	music_changed()



func _on_QuitButton_pressed():
	get_tree().quit()


func _on_SaveButton_pressed():
	PlayerData.save()
	$Saved.visible = true
	$Timer.start(1)
func music_changed():
	var musicPlaying = Music.musicPlaying()

	music.text = musicPlaying


func _on_Timer_timeout():
	$Saved.visible = false
