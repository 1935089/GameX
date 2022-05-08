extends Control

onready var texture1 = $"Inventory/1/Texture1"
onready var texture2 = $"Inventory/2/Texture2"
onready var texture3 = $"Inventory/3/Texture3"
onready var texture4 = $"Inventory/4/Texture4"
onready var texture5 = $"Inventory/5/Texture5"
onready var texture6 = $"Inventory/6/Texture6"
onready var texture7 = $"Inventory/7/Texture7"
onready var texture8 = $"Inventory/8/Texture8"
onready var texture9 = $"Inventory/9/Texture9"
onready var texture10 = $"Inventory/10/Texture10"
onready var texture11 = $"Inventory/11/Texture11"
onready var texture12 = $"Inventory/12/Texture12"
onready var texture13 = $"Inventory/13/Texture13"
onready var texture14 = $"Inventory/14/Texture14"
onready var texture15 = $"Inventory/15/Texture15"


onready var label1 = $"Inventory/1/Label1"
onready var label2 = $"Inventory/2/Label2"
onready var label3 = $"Inventory/3/Label3" 
onready var label4 = $"Inventory/4/Label4"
onready var label5 = $"Inventory/5/Label5"
onready var label6 = $"Inventory/6/Label6"
onready var label7 = $"Inventory/7/Label7"
onready var label8 = $"Inventory/8/Label8"
onready var label9 = $"Inventory/9/Label9"
onready var label10 = $"Inventory/10/Label10"
onready var label11 = $"Inventory/11/Label11"
onready var label12 = $"Inventory/12/Label12"
onready var label13 = $"Inventory/13/Label13"
onready var label14 = $"Inventory/14/Label14"
onready var label15 = $"Inventory/15/Label15"


onready var label1Hotbar = $"Hotbar/1/Label1"
onready var label2Hotbar = $"Hotbar/2/Label2"
onready var label3Hotbar = $"Hotbar/3/Label3"
onready var label4Hotbar = $"Hotbar/4/Label4"
onready var label5Hotbar = $"Hotbar/5/Label5"

onready var texture1Hotbar = $"Hotbar/1/Texture1"
onready var texture2Hotbar = $"Hotbar/2/Texture2"
onready var texture3Hotbar = $"Hotbar/3/Texture3"
onready var texture4Hotbar = $"Hotbar/4/Texture4"
onready var texture5Hotbar = $"Hotbar/5/Texture5"

var labelsInv = []
var texturesInv = []

var labelsHotbar = []
var texturesHotbar = []

var i = 0
var j = 0


func _ready():
	
# warning-ignore:return_value_discarded
	GameManager.connect("player_initialised", self, "_on_player_initialised")
	
	labelsInv = [
	label1,label2,label3,label4,label5,
	label6,label7,label8,label9,label10,
	label11,label12,label13,label14,label15
	]
	texturesInv = [
	texture1, texture2, texture3, texture4,texture5,
	texture6,texture7,texture8,texture9,texture10,
	texture11,texture12,texture13,texture14,texture15
	]
	labelsHotbar = [
	label1Hotbar,label2Hotbar,label3Hotbar,label4Hotbar,label5Hotbar,
	]
	texturesHotbar = [
		texture1Hotbar,texture2Hotbar,texture3Hotbar,texture4Hotbar,texture5Hotbar,
	]

func _on_player_initialised(player):
		
		player.inventory.connect("inventory_changed",self,"_on_player_inventory_changed")
		
func _on_player_inventory_changed(inventory):
	i = 0
	j = 7
	for item in inventory.get_items():

		if i < labelsInv.size():
			
			texturesInv[i].texture = inventory.get_item(i).texture
			labelsInv[i].text = " x%d" % [inventory.get_item(i).quantity]
			copy_to_hotbar(i,j)
		else:
			break

		i += 1
		j += 1

func copy_to_hotbar(i,j):
	if i < labelsHotbar.size():
		print(str(i) + " : i")
		print(str(j) + " : j")
		texturesHotbar[i].texture = texturesInv[j].texture
		labelsHotbar[i].text = labelsInv[j].text
	
