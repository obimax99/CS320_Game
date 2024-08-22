class_name HealthContainer 
extends Node

# potentially make health_changed only emit when (health - old_health != 0)
signal health_changed(amount)
signal health_depleted

@export var max_health: float = 100
@export var defense: float = 50
# following resists just for export, don't use in code
@export var _fire_resist: float = 0
@export var _ice_resist: float = 0
@export var _life_resist: float = 0
@export var _death_resist: float = 0
@export var _smash_resist: float = 0
@export var _stab_resist: float = 0
@onready var resist_dict: Dictionary = {
	"fire": _fire_resist,
	"ice": _ice_resist,
	"life": _life_resist,
	"death": _death_resist,
	"smash": _smash_resist,
	"stab": _stab_resist
	}

var health: float
var is_dead: bool = false


func _ready():
	health = max_health


func damage(amount, damage_type="smash"):
	var old_health = health
	#print(amount * (100/(100+defense)))
	#print(resist_dict[damage_type])
	var mitigated_damage = clamp((amount * (100/(100+defense))) - resist_dict[damage_type], 0, amount)
	health = clamp(health - mitigated_damage, 0, max_health)
	emit_signal("health_changed", health - old_health)



func heal(amount):
	var old_health = health
	health = clamp(health + amount, 0, max_health)
	emit_signal("health_changed", health - old_health)


func _on_health_changed(_amount):
	if is_zero_approx(health) and not is_dead:
		emit_signal("health_depleted")
		is_dead = true
