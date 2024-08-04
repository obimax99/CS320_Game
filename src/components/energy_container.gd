class_name EnergyContainer 
extends Node

# potentially make energy_changed only emit when (energy - old_energy != 0)
signal energy_changed(amount)
signal energy_depleted

@export var max_energy: float = 100

var energy: float


func _ready():
	energy = max_energy


func deplete_energy(amount):
	var old_energy = energy
	energy = clamp(energy - amount, 0, max_energy)
	emit_signal("energy_changed", energy - old_energy)


func energize(amount):
	var old_energy = energy
	energy = clamp(energy + amount, 0, max_energy)
	emit_signal("energy_changed", energy - old_energy)


func _on_energy_changed(_amount):
	print("energy: %s", energy)
	if is_zero_approx(energy):
		emit_signal("energy_depleted")
