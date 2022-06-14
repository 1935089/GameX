extends CanvasLayer

var is_paused = false
onready var settings = $Menu/Menu

func _input(event):
	if PlayerData.settings == false:
		if event.is_action_pressed("inventory"):
			if PlayerData.inventory_open == false:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
				
			$"Control/Equipment".visible = !$"Control/Equipment".visible
			$"Control/Inventory".visible = !$"Control/Inventory".visible
			PlayerData.inventory_open = !PlayerData.inventory_open
		elif event.is_action_pressed("scroll_up"):
			PlayerData.active_item_scroll_up()
		elif event.is_action_pressed("scroll_down"):
			PlayerData.active_item_scroll_down()
	if event.is_action_pressed("settings"):
		$Menu.visible = !$Menu.visible

		settings.visible = !settings.visible
		PlayerData.settings = !PlayerData.settings
		if PlayerData.settings == true:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().paused = true
			
		elif PlayerData.settings == false:
			
			get_tree().paused = false
			
	

