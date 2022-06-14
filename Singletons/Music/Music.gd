extends Node

signal showMusic 

var songPlaying

func _ready():
	randomize()
	$HappyMusic.play()

	emit_signal("showMusic")

func _on_Music_finished():
	$HappyMusic.play()
	emit_signal("showMusic")
	
func musicPlaying():
	songPlaying = $HappyMusic.stream.resource_path.get_basename().split("/")
	songPlaying = "   " + songPlaying[5] + " by " + songPlaying[3]
	return songPlaying
