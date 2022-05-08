extends Control

onready var texture1 = $"1/Texture1"
onready var texture2 = $"2/Texture2"
onready var texture3 = $"3/Texture3"
onready var texture4 = $"4/Texture4"
onready var texture5 = $"5/Texture5"
onready var texture6 = $"6/Texture6"
onready var texture7 = $"7/Texture7"
onready var texture8 = $"8/Texture8"
onready var texture9 = $"9/Texture9"
onready var texture10 = $"10/Texture10"
onready var texture11 = $"11/Texture11"
onready var texture12 = $"12/Texture12"
onready var texture13 = $"13/Texture13"
onready var texture14 = $"14/Texture14"
onready var texture15 = $"15/Texture15"


onready var label1 = $"1/Label1"
onready var label2 = $"2/Label2"
onready var label3 = $"3/Label3" 
onready var label4 = $"4/Label4"
onready var label5 = $"5/Label5"
onready var label6 = $"6/Label6"
onready var label7 = $"7/Label7"
onready var label8 = $"8/Label8"
onready var label9 = $"9/Label9"
onready var label10 = $"10/Label10"
onready var label11 = $"11/Label11"
onready var label12 = $"12/Label12"
onready var label13 = $"13/Label13"
onready var label14 = $"14/Label14"
onready var label15 = $"15/Label15"


var labels = []
var textures = []

var i = 0

func _ready():
	
# warning-ignore:return_value_discarded
	GameManager.connect("player_initialised", self, "_on_player_initialised")
	
	labels = [
	label1,label2,label3,label4,label5,
	label6,label7,label8,label9,label10,
	label11,label12,label13,label14,label15
	]
	textures = [
	texture1, texture2, texture3, texture4,texture5,
	texture6,texture7,texture8,texture9,texture10,
	texture11,texture12,texture13,texture14,texture15
	]

func _on_player_initialised(player):
		
		player.inventory.connect("inventory_changed",self,"_on_player_inventory_changed")
		
func _on_player_inventory_changed(inventory):
	i = 0
	
	for item in inventory.get_items():		

		if i < labels.size():
			textures[i].texture = inventory.get_item(i).texture
			labels[i].text = " x%d" % [inventory.get_item(i).quantity]
		else:
			break
		i += 1
