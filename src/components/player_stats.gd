#class_name PlayerStats
extends Node

# This signal is connected to player_menu - when stats are modified the changes are reflected in the UI
signal player_leveled_up
signal player_gained_xp



# Player base stats
@export var base_health: int
@export var base_defense: int
@export var base_hp_regen: int
@export var base_power: int
@export var base_dexterity: int
@export var base_speed: int
@export var base_energy: int
@export var base_energy_regen: int

#Player stat modifiers
var health_mod: int = 0
var defense_mod: int = 0
var hp_regen_mod: int = 0
var power_mod: int = 0
var dexterity_mod: int = 0
var speed_mod: int = 0
var energy_mod: int = 0
var energy_regen_mod: int = 0

#Player total stat values
var health: int
var defense: int
var hp_regen: int
var power: int
var dexterity: int
var speed: int
var energy: int
var energy_regen: int

var xp_level_thresholds: Array[int] = [100, 250, 500, 800, 1300, 2000, 2800, 3800, 5000]
var max_level = len(xp_level_thresholds) + 1
var xp: int = 0
var level: int = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	# Set initial player stat values when character is created
	base_health = 100
	base_hp_regen = 2
	base_defense = 20
	base_power = 20
	base_dexterity = 100
	base_speed = 200
	base_energy = 100
	base_energy_regen = 5
	update_stat_totals()


#Call anytime the base or bonus stat values are updated
func update_stat_totals():
	health = base_health + health_mod
	hp_regen = base_hp_regen + hp_regen_mod
	defense = base_defense + defense_mod
	power = base_power + power_mod
	dexterity = base_dexterity + dexterity_mod
	speed = base_speed + speed_mod
	energy = base_energy + energy_mod
	energy_regen = base_energy_regen + energy_regen_mod

#Call when enemy is killed or quest is completed
func gain_xp(amount):
	xp += amount;
	emit_signal("player_gained_xp")
	checkLevelUp()


# Checks if a character meets a threshold requried for leveling up
func checkLevelUp():
	var max_level = len(xp_level_thresholds)
	if level > max_level:
		return
	if xp >= xp_level_thresholds[level - 1]:
		levelUp()


# level up the character
func levelUp():
	base_health += 20
	base_hp_regen += 2
	base_defense += 2
	base_power += 2
	base_dexterity += 5
	base_speed += 2
	base_energy += 2
	base_energy_regen += 2
	level += 1
	update_stat_totals()
	var Player = get_parent()
	Player.set_health()
	Player.set_speed()
	emit_signal("player_leveled_up")
