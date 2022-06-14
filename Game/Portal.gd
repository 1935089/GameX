tool
extends Area2D


export (String, FILE) var next_scene_path = ""
export (Vector2) var player_spawn_location = Vector2.ZERO
export (Vector2) var player_direction = Vector2(0,1)


func _get_configuration_warning() -> String:
	if next_scene_path == "":
		return "next_scene_path must be set for the portal to work"
	else:
		return ""


func _on_Portal_body_entered(_body):
	PlayerData.changing_map = true
	Global.player_initial_map_position = player_spawn_location
	Global.player_facing_direction = player_direction
	PlayerData.inventory_open = false
	if get_tree().change_scene(next_scene_path) != OK:
		print("Error: Unavailable scene!")
	var world = next_scene_path.split("/")
	world = world[3]
	world = world.split(".")
	world = world[0]
	PlayerData.player_data["Player"]["World"] = world
	$Timer.start(0.1)
	
	


func _on_Timer_timeout():
	PlayerData.changing_map = false
