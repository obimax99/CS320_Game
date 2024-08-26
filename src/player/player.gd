extends CharacterBody2D
class_name Player

signal toggle_inventory()
# DEBUG
var invincibility: bool = false
# END DEBUG

var sync_pos := Vector2.ZERO
var mult_sync: MultiplayerSynchronizer

@onready var health_bar: ProgressBar = %HealthBar
@onready var health_container: HealthContainer = %HealthContainer
@onready var energy_bar: ProgressBar = %EnergyBar
@onready var energy_container: EnergyContainer = %EnergyContainer
@onready var motion_controller: MotionController = %MotionController

@export_category("Inventories")
@export var inventory_data: InventoryData
@export var weapon_inventory_data: InventoryDataWeapon
@export var offhand_inventory_data: InventoryDataWeapon
@export var consumable_inventory_data: InventoryDataConsumable
@export var armor_inventory_data: InventoryDataArmor
@export var trinket_inventory_data: InventoryDataTrinket
var equipped_weapon: Weapon
var starting_item_data_weapon: ItemDataWeapon
const EQUIP_INVENTORY_WEAPON = 0
var holding_left_click: bool = false
var holding_right_click: bool = false

@onready var player_stats = $PlayerStats

func _ready():
	if multiplayer.get_unique_id() == str(name).to_int():
		set_health()
		PlayerManager.player = self
		weapon_inventory_data.weapon_changed.connect(change_weapon)
		weapon_inventory_data.weapon_removed.connect(removed_weapon)
		# exported inventories: would likely start based on class selection
		# based on class, select starting weapon
		# for now, using a default starting_weapon resource of dagger
		starting_item_data_weapon = preload("res://src/items/daggers/dagger1.tres")
		# again, this is based off of the test_weapon_inventory.tres having
		# a dagger. 
		change_weapon(starting_item_data_weapon)
		$Camera2D.make_current()

func set_health(): # and defense!
	health_container.defense = player_stats.defense
	health_container.max_health = player_stats.health
	health_container.health = player_stats.health
	health_bar.max_value = health_container.max_health
	health_bar.value = health_container.health
	
func set_energy():
	energy_container.max_energy = player_stats.energy
	energy_container.energy = player_stats.energy
	energy_bar.max_value = energy_container.max_energy
	energy_bar.value = energy_container.energy

func set_speed():
	motion_controller.max_speed = player_stats.speed

func _process(_delta):
	# only move the player if we are the client controlling them
	if mult_sync.get_multiplayer_authority() == multiplayer.get_unique_id():
		sync_pos = global_position
		move(_delta)
		# check inventory toggle
		if Input.is_action_just_pressed("toggle_invincibility"):
			toggle_invincibility()
		if Input.is_action_just_pressed("toggle_inventory"):
			toggle_inventory.emit()
		if Input.is_action_just_pressed("interact"):
			interact()
		if holding_left_click:
			equipped_weapon.basic_attack()
		if holding_right_click:
			equipped_weapon.item_special()
		#if Input.is_action_pressed("basic_attack") and equipped_weapon:
			#equipped_weapon.basic_attack()
			##%SwingSound.play(0.2)
		#if Input.is_action_pressed("item_special") and equipped_weapon:
			#equipped_weapon.item_special()
	else:
		global_position = global_position.lerp(sync_pos, 0.4)

func _unhandled_input(event):
	if not mult_sync.get_multiplayer_authority() == multiplayer.get_unique_id():
		return
	if not equipped_weapon:
		return
		
	if event.is_action_pressed("basic_attack"):
		holding_left_click = true
	elif event.is_action_released("basic_attack"):
		holding_left_click = false
	elif event.is_action_pressed("item_special"):
		holding_right_click = true
	elif event.is_action_released("item_special"):
		holding_right_click = false

func _unhandled_key_input(event):
	if event.is_action_pressed("swap_weapons"):
		var temp_grabbed_slot: SlotData = weapon_inventory_data.grab_slot_data(0)
		if (temp_grabbed_slot == null):
			temp_grabbed_slot = offhand_inventory_data.grab_slot_data(0)
		else:
			temp_grabbed_slot = offhand_inventory_data.drop_slot_data(temp_grabbed_slot, 0)
		if (temp_grabbed_slot != null):
			weapon_inventory_data.drop_slot_data(temp_grabbed_slot, 0)
		print("swapped")
		
func move(_delta):
	
	# get acceleration direction
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# apply friction if no input is pressed
	if direction.length() == 0:
		motion_controller.apply_friction(_delta)
	
	# apply acceleration and limit velocity
	motion_controller.move(direction, _delta)
	
	# move the player
	velocity = motion_controller.velocity
	move_and_slide()
	

func toggle_invincibility():
	print("invincibility toggled")
	if (!invincibility):
		health_container.resist_dict["fire"] = 1000
		health_container.resist_dict["ice"] = 1000
		health_container.resist_dict["life"] = 1000
		health_container.resist_dict["death"] = 1000
		health_container.resist_dict["smash"] = 1000
		health_container.resist_dict["stab"] = 1000
	else:
		health_container.resist_dict["fire"] = 0
		health_container.resist_dict["ice"] = 0
		health_container.resist_dict["life"] = 0
		health_container.resist_dict["death"] = 0
		health_container.resist_dict["smash"] = 0
		health_container.resist_dict["stab"] = 0
	invincibility = !invincibility

func _on_health_container_health_changed(_amount):
	health_bar.value = health_container.health
	if _amount < 0:
		%HurtSound.play(0.75)
		
		
func _on_energy_container_energy_changed(_amount):
	energy_bar.value = energy_container.energy
	#if _amount < 0:
		#print("used energy!")


func _on_health_container_health_depleted():
	%DeathAnimator.animate()
	queue_free()


func _on_tree_entered():
	mult_sync = %MultiplayerSynchronizer
	mult_sync.set_multiplayer_authority(str(name).to_int())
	
func interact():
	print("interact")
	
func get_drop_position() -> Vector2:
	var current_position = global_position
	current_position += Vector2(40, -40)
	return current_position
	
func heal(amount: int):
	health_container.heal(amount)
	
func energize(amount: int):
	energy_container.energize(amount)

func change_weapon(weapon_item_data: ItemDataWeapon):
	if equipped_weapon:
		equipped_weapon.queue_free()
	equipped_weapon = weapon_item_data.weapon.instantiate()
	equipped_weapon.weapon_rarity = weapon_item_data.weapon_rarity
	add_child(equipped_weapon)
	print("equipped weapon has been changed to: %s" % weapon_item_data.name)

func removed_weapon():
	equipped_weapon = null
