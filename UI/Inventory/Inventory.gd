extends Control
var potionDrop
var template_inv_slot = preload("res://UI/Inventory/InvSlot.tscn")

onready var gridContainer = get_node("GridContainer2")


func _ready():
# warning-ignore:return_value_discarded
	AddItem.connect("inv_changed", self, "inv_update")

	for i in PlayerData.inv_data.keys():
		var inv_slot_new = template_inv_slot.instance()
		if PlayerData.inv_data[i]["Item"] != null:
			
			var item_name = GameData.item_data[str(PlayerData.inv_data[i]["Item"])]["Name"]
			var file_name = GameData.item_data[str(PlayerData.inv_data[i]["Item"])]["File"]
			var icon_texture = load("res://Assets/Icon_Items/"+file_name +"/"+ item_name + ".png")
			
			inv_slot_new.get_node("Icon").set_texture(icon_texture)
			var item_stack = PlayerData.inv_data[i]["Stack"]
			if item_stack != null and item_stack > 1:
				
				inv_slot_new.get_node("Stack").set_text(str(item_stack))


		gridContainer.add_child(inv_slot_new, true)

func inv_update():
	
	for i in gridContainer.get_children():
		gridContainer.remove_child(i)
		i.free()
	for i in PlayerData.inv_data.keys():
		var inv_slot_new = template_inv_slot.instance()
		if PlayerData.inv_data[i]["Item"] != null:
			
			var item_name = GameData.item_data[str(PlayerData.inv_data[i]["Item"])]["Name"]
			var file_name = GameData.item_data[str(PlayerData.inv_data[i]["Item"])]["File"]
			var icon_texture = load("res://Assets/Icon_Items/"+file_name +"/"+ item_name + ".png")
			
			inv_slot_new.get_node("Icon").set_texture(icon_texture)
			var item_stack = PlayerData.inv_data[i]["Stack"]
			if item_stack != null and item_stack > 1:
				
				inv_slot_new.get_node("Stack").set_text(str(item_stack))
		gridContainer.add_child(inv_slot_new, true)

