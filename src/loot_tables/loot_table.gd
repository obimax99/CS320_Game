extends Resource
class_name LootTable


@export_category("Weapons")
@export var min_weapon_drops: int = 0
@export var max_weapon_drops: int = 1
@export_range(0, 100, 0.1, "suffix: %") var weapon_drop_chance: float = 0
@export_group("Tier Drop Rates")
@export_range(0, 100, 0.1, "suffix: %") var weapon_t1_drop_rate: float = 0
@export_range(0, 100, 0.1, "suffix: %") var weapon_t2_drop_rate: float = 0
@export_range(0, 100, 0.1, "suffix: %") var weapon_t3_drop_rate: float = 0
@export_range(0, 100, 0.1, "suffix: %") var weapon_t4_drop_rate: float = 0
@export_range(0, 100, 0.1, "suffix: %") var weapon_t5_drop_rate: float = 0
@export_group("Which Weapons Drop")
@export var dagger_drop: bool
@export var mage_staff_drop: bool

var weapon_t1_dict
var weapon_t2_dict
var weapon_t3_dict
var weapon_t4_dict
var weapon_t5_dict
var weapon_dict_array: Array[Dictionary]
var weapons_dict


@export_category("Consumables")
@export_group("Health Potion")
@export var min_health_potion_drops: int = 0
@export var max_health_potion_drops: int = 1
@export_range(0, 100, 0.1, "suffix: %") var health_potion_drop_rate: float = 0
@export var health_potion_drop: bool


func set_non_exported_vals():
	# minimum drops is not yet supported but I don't want to remove it yet
	min_weapon_drops = 0
	min_health_potion_drops = 0
	weapon_t1_dict = {
		"tier": 1, 
		"drop_rate": weapon_t1_drop_rate
	}
	weapon_t2_dict = {
		"tier": 2, 
		"drop_rate": weapon_t2_drop_rate
	}
	weapon_t3_dict = {
		"tier": 3, 
		"drop_rate": weapon_t3_drop_rate
	}
	weapon_t4_dict = {
		"tier": 4, 
		"drop_rate": weapon_t4_drop_rate
	}
	weapon_t5_dict = {
		"tier": 5, 
		"drop_rate": weapon_t5_drop_rate
	}
	weapon_dict_array = [weapon_t1_dict, weapon_t2_dict, weapon_t3_dict, weapon_t4_dict, weapon_t5_dict]
	weapon_dict_array.sort_custom(custom_dict_array_sort)
	
	weapons_dict = {
		"dagger": dagger_drop,
		"mage_staff": mage_staff_drop
	}
	
	
	
func custom_dict_array_sort(dict_a: Dictionary, dict_b: Dictionary) -> bool:
	return dict_a.drop_rate > dict_b.drop_rate
	