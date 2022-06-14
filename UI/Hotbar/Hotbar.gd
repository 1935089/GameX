extends Control



onready var icon1 = $"HBoxContainer/1/Icon"
onready var icon2 = $"HBoxContainer/2/Icon"
onready var icon3 = $"HBoxContainer/3/Icon"
onready var icon4 = $"HBoxContainer/4/Icon"
onready var icon5 = $"HBoxContainer/5/Icon"

onready var stack1 = $"HBoxContainer/1/Stack"
onready var stack2 = $"HBoxContainer/2/Stack"
onready var stack3 = $"HBoxContainer/3/Stack"
onready var stack4 = $"HBoxContainer/4/Stack"
onready var stack5 = $"HBoxContainer/5/Stack"

onready var bg1 = $"HBoxContainer/1/TextureSelected"
onready var bg2 = $"HBoxContainer/2/TextureSelected"
onready var bg3 = $"HBoxContainer/3/TextureSelected"
onready var bg4 = $"HBoxContainer/4/TextureSelected"
onready var bg5 = $"HBoxContainer/5/TextureSelected"



var icons= []
var stacks = []
var bgs = []
func _ready():
	
	icons= [icon1,icon2,icon3,icon4,icon5]
	stacks = [stack1,stack2,stack3,stack4,stack5]
	bgs = [bg1,bg2,bg3,bg4,bg5]
# warning-ignore:return_value_discarded
	AddItem.connect("hotbar_changed", self, "load_hotbar")
	load_hotbar()
# warning-ignore:return_value_discarded
	PlayerData.connect("active_item_updated", self, "selected_slot")
		

func load_hotbar():
	selected_slot()
	var count = 0
	
	for i in PlayerData.hotbar_data:
		
		
		if PlayerData.hotbar_data[i]["Item"] != null:
			
			var item_name = GameData.item_data[str(PlayerData.hotbar_data[i]["Item"])]["Name"]
			
			var file_name = GameData.item_data[str(PlayerData.hotbar_data[i]["Item"])]["File"]
			var icon_texture = load("res://Assets/Icon_Items/"+file_name +"/"+ item_name + ".png")
			icons[count].set_texture(icon_texture)
			
			var item_stack = PlayerData.hotbar_data[i]["Stack"]
			
			if item_stack != null and item_stack >= 1 and GameData.item_data[str(PlayerData.hotbar_data[i]["Item"])]["Stackable"] == true:
				
				stacks[count].set_text(str(item_stack))
				
		if PlayerData.hotbar_data[i]["Stack"] == 0:
			PlayerData.hotbar_data[i]["Item"] = null
			PlayerData.hotbar_data[i]["Stack"] = null
			icons[count].set_texture(null)
			stacks[count].set_text("")
		count += 1
			
func selected_slot():
	
	var selected_slot_only = bgs.slice(0,6)
	
	selected_slot_only.remove(PlayerData.active_item_slot)
	
	bgs[PlayerData.active_item_slot].visible = true

	for i in selected_slot_only.size():
		selected_slot_only[i].visible = false
		
	if PlayerData.hotbar_data[str(PlayerData.active_item_slot + 1)]["Item"] != null:
		PlayerData.held_item = PlayerData.hotbar_data[str(PlayerData.active_item_slot + 1)]["Item"]

