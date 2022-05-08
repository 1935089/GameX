extends Control

var energy = 4 setget set_energy
var max_energy = 4 setget set_max_energy

onready var energyUIFull = $EnergyUIFull
onready var energyUIEmpty = $EnergyUIEmpty


func set_energy(value):
	
	energy = clamp(value, 0, max_energy)
	
	if energyUIFull != null:
		energyUIFull.rect_size.x = energy * 15 #pcq les energy sont 15px wide
		
func set_max_energy(value):
	max_energy = max(value, 1)
	self.energy = min(energy,max_energy)
	if energyUIEmpty != null:
		energyUIEmpty.rect_size.x = max_energy * 15 #pcq les energy sont 15px wide
		
func _ready():

	self.max_energy = PlayerStats.max_energy
	self.energy = PlayerStats.energy
# warning-ignore:return_value_discarded
	PlayerStats.connect("energy_changed", self, "set_energy")
	
# warning-ignore:return_value_discarded
	PlayerStats.connect("max_energy_changed",self,"self_max_energy")
	


