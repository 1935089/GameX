extends Node


export(int) var max_health = 1 setget set_max_health
var health = max_health setget set_health

export(int) var max_energy = 1 setget set_max_energy
var energy = max_energy setget set_energy

signal no_health

signal health_changed(value)
signal max_health_changed(value)
signal energy_changed(value)
signal max_energy_changed(value)

func set_max_health(value):
	
	max_health = value
	emit_signal("max_health_changed")


func set_health(value):
	
	health = value
	
	emit_signal("health_changed", health)	
	if health<= 0:
		emit_signal("no_health")

	
func set_max_energy(value):
	
	max_energy = value
	emit_signal("max_energy_changed")

	
func set_energy(value):

	energy = value
	
	emit_signal("energy_changed", energy)
	



