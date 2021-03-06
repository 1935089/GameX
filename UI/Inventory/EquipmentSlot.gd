extends TextureRect

onready var tool_tip = preload("res://UI/Inventory/Tooltip.tscn")

func _ready():
# warning-ignore:return_value_discarded
	connect("mouse_entered",self,"_on_Icon_mouse_entered")
# warning-ignore:return_value_discarded
	connect("mouse_exited",self,"_on_Icon_mouse_exited")
	
func get_drag_data(_pos):
	var equipment_slot = get_parent().get_name()
	
	if PlayerData.equipment_data["Armor"][equipment_slot] != null:
		
		var data= {}
		
		data["origin_node"] = self
		data["origin_panel"] = "Equipment"
		data["origin_item_id"] = PlayerData.equipment_data["Armor"][equipment_slot]
		data["origin_equipment_slot"] = equipment_slot
		data["origin_stackable"] = false
		data["origin_stack"] = 1
		data["origin_texture"] = texture
		
		var drag_texture = TextureRect.new()
		
		drag_texture.expand = true
		drag_texture.texture = texture
		drag_texture.rect_size = Vector2(14,14)
		
		var control = Control.new()
		control.add_child(drag_texture)
		drag_texture.rect_position = -0.5 * drag_texture.rect_size
		set_drag_preview(control)
		
		return data
	
func can_drop_data(_pos, data):
	
	var target_equipment_slot = get_parent().get_name()
	
	if target_equipment_slot == data["origin_equipment_slot"]:
		if PlayerData.equipment_data["Armor"][target_equipment_slot] == null:
			
			data["target_item_id"] = null
			data["target_texture"] = null
			
		else:
			data["target_item_id"] = PlayerData.equipment_data["Armor"][target_equipment_slot]
			data["target_texture"] = texture
		return true
	else:
		return false
	
func drop_data(_pos,data):
	var target_equipment_slot = get_parent().get_name()
	var origin_slot = data["origin_node"].get_parent().get_name()
	
	if data["origin_panel"] == "Inventory":
		PlayerData.inv_data[origin_slot]["Item"] = data["target_item_id"]
	elif data["origin_panel"] == "Hotbar":
		PlayerData.hotbar_data[origin_slot]["Item"] = data["target_item_id"]
	else:
		PlayerData.equipment_data[origin_slot] = data["target_item_id"]
		
	if data["origin_panel"] == "Equipment" and data["target_item_id"] == null:
		var default_texture = load("res://Assets/UI_Elements/" + origin_slot + "_default_icon.png")
		data["origin_node"].texture = default_texture
		
	else:
		data["origin_node"].texture = data["target_texture"]

	PlayerData.equipment_data["Armor"][target_equipment_slot] = data["origin_item_id"]
	texture = data["origin_texture"]
	
func _on_Icon_mouse_entered():
	
	var tool_tip_instance = tool_tip.instance()
	tool_tip_instance.origin = "Equipment"
	tool_tip_instance.slot = get_parent().get_name()
	tool_tip_instance.rect_position = get_parent().get_global_transform_with_canvas().origin - Vector2(115,-22)
	
	add_child(tool_tip_instance)
	yield(get_tree().create_timer(0.35), "timeout")
	if has_node("Tooltip") and get_node("Tooltip").valid:
		
		get_node("Tooltip").show()
	
func _on_Icon_mouse_exited():

		get_node("Tooltip").free()

func _input(event):

	if event.is_action_pressed("inventory"):
		if has_node("Tooltip") and get_node("Tooltip").valid:
			get_node("Tooltip").free()

