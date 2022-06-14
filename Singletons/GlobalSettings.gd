extends Node


signal brightness_updated(value)


func toggle_fullscreen(toggle):
	OS.window_fullscreen = toggle
	Settings.game_data.fullscreen_on = toggle
	Settings.save_data()
	
	
	
func update_brightness(value):
	emit_signal("brightness_updated", value)
	Settings.game_data.brightness = value
	Settings.save_data()
	
	
func update_master_vol(vol):
	AudioServer.set_bus_volume_db(0, vol)
	Settings.game_data.master_vol = vol
	Settings.save_data()
	
	
func update_music_vol(vol):
	AudioServer.set_bus_volume_db(1, vol)
	Settings.game_data.music_vol = vol
	Settings.save_data()
	
		
func update_sound_vol(vol):
	AudioServer.set_bus_volume_db(2, vol)
	Settings.game_data.sound_vol = vol
	Settings.save_data()
	
	

