extends CanvasLayer



func _input(event):
	if event.is_action_pressed("inventory"):
		$"Control/Inventory".visible = !$"Control/Inventory".visible
		$"Control/Hotbar".visible = !$"Control/Hotbar".visible
