extends Node

signal inv_changed
signal hotbar_changed

func add_to_inv(id, slot):
	for i in PlayerData.inv_data:
		if PlayerData.inv_data[i]["Item"] == id and GameData.item_data[str(id)]["Stackable"] == true:
				PlayerData.inv_data[i]["Stack"] += 1
				slot = PlayerData.inv_data[i]
				emit_signal("inv_changed")
				break
		if PlayerData.inv_data[i]["Item"] == null and GameData.item_data[str(id)]["Stackable"] == false:	
			PlayerData.inv_data[i]["Item"] = id
			PlayerData.inv_data[i]["Stack"] = 1
			emit_signal("inv_changed")
			break
	
	if slot == null:
		for i in PlayerData.inv_data:
			if PlayerData.inv_data[i]["Item"] == null and GameData.item_data[str(id)]["Stackable"] == true:
				PlayerData.inv_data[i]["Item"] = id
				PlayerData.inv_data[i]["Stack"] = 1
				emit_signal("inv_changed")
				break	

func add_to_hotbar(id): 
	
	for i in PlayerData.hotbar_data:
		
		if PlayerData.hotbar_data[i]["Item"] == id and GameData.item_data[str(id)]["Stackable"] == true:
				
			PlayerData.hotbar_data[i]["Stack"] += 1
			
			emit_signal("hotbar_changed")
			break
		if PlayerData.hotbar_data[i]["Item"] == null and GameData.item_data[str(id)]["Stackable"] == true:	
			PlayerData.hotbar_data[i]["Item"] = id
			PlayerData.hotbar_data[i]["Stack"] = 1
			emit_signal("hotbar_changed")
			
			break
		if PlayerData.hotbar_data[i]["Item"] == null and GameData.item_data[str(id)]["Stackable"] == false:	
			
			PlayerData.hotbar_data[i]["Item"] = id
			PlayerData.hotbar_data[i]["Stack"] = 1
			emit_signal("hotbar_changed")
			
			break
		if PlayerData.hotbar_data[i]["Item"] == id and PlayerData.hotbar_data[i]["Stack"] == 16:
				if PlayerData.hotbar_data[i]["Item"] == null and GameData.item_data[str(id)]["Stackable"] == true:
					
					PlayerData.hotbar_data[i]["Item"] = id
					PlayerData.hotbar_data[i]["Stack"] = 1
					emit_signal("hotbar_changed")
					break		

func add_items(id, slot):
	var count = 0

	if GameData.item_data[str(id)]["Stackable"] == true:
		for i in PlayerData.inv_data:
			if PlayerData.inv_data[i]["Item"] == id:
				AddItem.add_to_inv(id,slot)
				return
	
	for i in PlayerData.hotbar_data:

		if PlayerData.hotbar_data[i]["Item"] != id and PlayerData.hotbar_data[i]["Item"] != null:
			count += 1
		
		elif str(GameData.item_data[str(id)]["Stackable"]) == "False" and PlayerData.hotbar_data[i]["Item"] != null :
			count +=1


	if count == 5:
		AddItem.add_to_inv(id,slot)
		
	else:

		AddItem.add_to_hotbar(id)
		

func item_used():
	PlayerData.hotbar_data[str(PlayerData.active_item_slot + 1)]["Stack"] -= 1
	emit_signal("hotbar_changed")
