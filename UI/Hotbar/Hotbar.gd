extends Control

onready var texture1 = $"1/Texture1"
onready var texture2 = $"2/Texture2"
onready var texture3 = $"3/Texture3"
onready var texture4 = $"4/Texture4"
onready var texture5 = $"5/Texture5"
onready var texture11Inv = $"Inventory/11/Texture11"



onready var label1 = $"1/Label1"
onready var label2 = $"2/Label2"
onready var label3 = $"3/Label3" 
onready var label4 = $"4/Label4"
onready var label5 = $"5/Label5"



var labels = []
var textures = []

var i = 0

func _ready():
	
# warning-ignore:return_value_discarded
	GameManager.connect("player_initialised", self, "_on_player_initialised")
	
	labels = [
	label1,label2,label3,label4,label5
	]
	textures = [
	texture1, texture2, texture3, texture4,texture5
	]

func _on_player_initialised(player):
		
		player.inventory.connect("inventory_changed",self,"_on_player_inventory_changed")
		
func _on_player_inventory_changed(inventory):
	
	
	for item in inventory.get_items():		
		if i < labels.size():
			textures[i].texture = inventory.get_item(i).texture
			labels[i].text = " x%d" % [inventory.get_item(i).quantity]
		else:
				
			break
	i += 1
