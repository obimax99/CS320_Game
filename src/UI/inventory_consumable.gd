extends PanelContainer

signal consumable_use(index: int)

const Slot = preload("res://src/UI/slot.tscn")

@onready var v_box_container = $MarginContainer/VBoxContainer
@export var inv_h_separation: int = 4


func _ready():
	v_box_container.add_theme_constant_override("separation", inv_h_separation)


# i think this might not work well in multiplayer but i dont know enough
func _unhandled_key_input(event):
	if not event.is_pressed():
		return
	
	# these calculations just emit 0-3 based on number keys 1-4 being pressed
	if range(KEY_1, KEY_5).has(event.keycode):
		consumable_use.emit(event.keycode - KEY_1)


func set_inventory_data(inventory_data: InventoryData):
	inventory_data.inventory_updated.connect(populate_item_grid)
	populate_item_grid(inventory_data)
	consumable_use.connect(inventory_data.use_slot_data)

func populate_item_grid(inventory_data: InventoryData):
	for child in v_box_container.get_children():
		child.queue_free()
		
	for slot_data in inventory_data.slot_datas:
		var slot = Slot.instantiate()
		v_box_container.add_child(slot)
		
		slot.slot_clicked.connect(inventory_data.on_slot_clicked)
		
		if slot_data:
			slot.set_slot_data(slot_data)
		else:
			slot.set_consumable_slot_texture()
