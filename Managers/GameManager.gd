extends Node


signal player_initialised
# warning-ignore:unused_signal
signal inventory_changed

var player


	
		
func initialise_player():
	yield(get_tree(),"idle_frame")
	player = get_tree().get_root().get_node("/root/"+str(get_tree().get_current_scene().get_name())+"/YSort/Player")
	
	if not player:
		return
	emit_signal("player_initialised", player)
	
	player.inventory.connect("inventory_changed",self,"_on_player_inventory_changed")
	
	var existing_inventory = load("user://inventory.tres")
	if existing_inventory:
		player.inventory.set_items(existing_inventory.get_items())
		
		
	else:
		print("Inventory does not exist")
	
func _on_player_inventory_changed(inventory):
# warning-ignore:return_value_discarded

	ResourceSaver.save("user://inventory.tres", inventory)
