extends Control


onready var helmet = $Helmet/Icon
onready var chestplate = $Chestplate/Icon
onready var pants = $Pants/Icon
onready var boots = $Boots/Icon

func _ready():
	

	load_equipment("Helmet", helmet)
	load_equipment("Chestplate", chestplate)
	load_equipment("Pants", pants)
	load_equipment("Boots", boots)
		
		
func load_equipment(name, icon):
	
	if PlayerData.equipment_data["Armor"][name] != null:
		var item_name = GameData.item_data[str(PlayerData.equipment_data["Armor"][name])]["Name"]
		var file_name = GameData.item_data[str(PlayerData.equipment_data["Armor"][name])]["File"]
		var icon_texture = load("res://Assets/Icon_Items/"+file_name +"/"+ item_name + ".png")
		
		icon.set_texture(icon_texture)

