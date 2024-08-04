extends ItemData
class_name ItemDataConsumable

@export var health_recover_value: int
@export var energy_recover_value: int

func use(target):
	if health_recover_value != 0:
		target.heal(health_recover_value)
	if energy_recover_value != 0:
		target.energize(energy_recover_value)

