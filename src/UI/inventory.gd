extends PanelContainer

const Slot = preload("res://src/UI/slot.tscn")

@onready var item_grid = $MarginContainer/ItemGrid
@export var item_grid_columns: int = 6
@export var inv_h_separation: int = 4
@export var inv_v_separation: int = 4

func _ready():
	item_grid.set_columns(item_grid_columns)
	item_grid.add_theme_constant_override("h_separation", inv_h_separation)
	item_grid.add_theme_constant_override("v_separation", inv_v_separation)

func set_inventory_data(inventory_data: InventoryData):
	inventory_data.inventory_updated.connect(populate_item_grid)
	populate_item_grid(inventory_data)

func populate_item_grid(inventory_data: InventoryData):
	for child in item_grid.get_children():
		child.queue_free()
		
	for slot_data in inventory_data.slot_datas:
		var slot = Slot.instantiate()
		item_grid.add_child(slot)
		
		slot.slot_clicked.connect(inventory_data.on_slot_clicked)
		
		if slot_data:
			slot.set_slot_data(slot_data)
		else:
			match inventory_data.get_inventory_type():
				"InventoryDataWeapon":
					slot.set_weapon_slot_texture()
				"InventoryDataArmor":
					slot.set_armor_slot_texture()
				"InventoryDataTrinket":
					slot.set_trinket_slot_texture()
