extends Node

signal active_item_updated

const ITEM_SLOTS = 5

var active_item_slot = 0

var held_item = null

var inv_data = {}
var hotbar_data = {}
var equipment_data = {"Armor":{
	"Helmet" : null,
	"Chestplate" : null,
	"Pants" : null,
	"Boots" : null
	}
}
var player_data = {}

var inventory_open = false
var settings = false



var username = ""

var changing_map = false

var can_save = true

var checkpoint

var dead = false



func _ready():
	var inv_data_file = File.new()
	while inv_data_file.file_exists("user://inv_data_file.json") == false:
		if inv_data_file.file_exists("user://inv_data_file.json") == false:
			var dir = Directory.new();
			dir.copy("res://Player/inv_data_file.json","user://inv_data_file.json");
	inv_data_file.open("user://inv_data_file.json", File.READ)
	var inv_data_json = JSON.parse(inv_data_file.get_as_text())
	inv_data_file.close()
	inv_data = inv_data_json.result

	var equ_data_file = File.new()
	while equ_data_file.file_exists("user://equ_data_file.json") == false:
		if equ_data_file.file_exists("user://equ_data_file.json") == false:
			var dir = Directory.new();
			dir.copy("res://Player/equ_data_file.json","user://equ_data_file.json");
	equ_data_file.open("user://equ_data_file.json", File.READ)
	var equ_data_json = JSON.parse(equ_data_file.get_as_text())
	equ_data_file.close()
	equipment_data = equ_data_json.result
	
	var hotbar_data_file = File.new()
	while hotbar_data_file.file_exists("user://hotbar_data_file.json") == false:
		if hotbar_data_file.file_exists("user://hotbar_data_file.json") == false:
			var dir = Directory.new();
			dir.copy("res://Player/hotbar_data_file.json","user://hotbar_data_file.json");
	hotbar_data_file.open("user://hotbar_data_file.json", File.READ)
	var hotbar_data_json = JSON.parse(hotbar_data_file.get_as_text())
	hotbar_data_file.close()
	hotbar_data = hotbar_data_json.result
	
	var player_data_file = File.new()
	while player_data_file.file_exists("user://player_data_file.json") == false:
		if player_data_file.file_exists("user://player_data_file.json") == false:
			var dir = Directory.new();
			dir.copy("res://Player/hotbar_data_file.json","user://player_data_file.json");
	player_data_file.open("user://player_data_file.json", File.READ)
	var player_data_json = JSON.parse(player_data_file.get_as_text())
	player_data_file.close()
	player_data = player_data_json.result
	

	
func save():
	var inv_data_file = File.new()
	inv_data_file.open("user://inv_data_file.json", File.WRITE)
	inv_data_file.store_string(JSON.print(inv_data, "\t"))
	inv_data_file.close()
	
	
	var equ_data_file = File.new()
	equ_data_file.open("user://equ_data_file.json", File.WRITE)
	equ_data_file.store_string(JSON.print(equipment_data, "\t"))
	equ_data_file.close()
 
	var hotbar_data_file = File.new()
	hotbar_data_file.open("user://hotbar_data_file.json", File.WRITE)
	hotbar_data_file.store_string(JSON.print(hotbar_data, "\t"))
	hotbar_data_file.close()

	save_player_hp_energy()
	
	var player_data_file = File.new()
	player_data_file.open("user://player_data_file.json", File.WRITE)
	player_data_file.store_string(JSON.print(player_data, "\t"))
	player_data_file.close()
	
func save_player_hp_energy():
	
	PlayerData.player_data["Player"]["Max_HP"] = PlayerStats.max_health
	
	
	PlayerData.player_data["Player"]["HP"] = PlayerStats.health
	
	
	PlayerData.player_data["Player"]["Max_Energy"] = PlayerStats.max_energy
	
	
	PlayerData.player_data["Player"]["Energy"] = PlayerStats.energy

	
func active_item_scroll_up():
	active_item_slot = (active_item_slot+1) % ITEM_SLOTS
	emit_signal("active_item_updated")
	
func active_item_scroll_down():
	if active_item_slot == 0:
		active_item_slot = ITEM_SLOTS - 1
	else:
		active_item_slot -= 1
	emit_signal("active_item_updated")
		
func player_armor():
	var armor = 0
	if PlayerData.equipment_data["Armor"]["Helmet"] != null:
		armor += GameData.item_data[str(PlayerData.equipment_data["Armor"]["Helmet"])]["Defense"]
	if PlayerData.equipment_data["Armor"]["Chestplate"] != null:
		armor += GameData.item_data[str(PlayerData.equipment_data["Armor"]["Chestplate"])]["Defense"]
	if PlayerData.equipment_data["Armor"]["Pants"] != null:
		armor += GameData.item_data[str(PlayerData.equipment_data["Armor"]["Pants"])]["Defense"]
	if PlayerData.equipment_data["Armor"]["Boots"] != null:
		armor += GameData.item_data[str(PlayerData.equipment_data["Armor"]["Boots"])]["Defense"]
	return armor
