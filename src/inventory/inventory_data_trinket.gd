extends InventoryData
class_name InventoryDataTrinket

func drop_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	
	# check if weapon is legal for class
	
	if not grabbed_slot_data.item_data is ItemDataTrinket:
		return grabbed_slot_data
	
	return super.drop_slot_data(grabbed_slot_data, index)

func drop_single_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	
	# check if weapon is legal for class
	
	if not grabbed_slot_data.item_data is ItemDataTrinket:
		return grabbed_slot_data
	
	return super.drop_single_slot_data(grabbed_slot_data, index)

func get_inventory_type() -> String:
	return "InventoryDataTrinket"
