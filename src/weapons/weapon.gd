extends Node2D
class_name Weapon

@export_range(1, 6, 1) var weapon_rarity: int = 1
var attack_speed: float = 1.0
var projectile_damage: float = 10
@export var projectile_speed: float = 300
@export_range(5, 1000, 1) var projectile_range: float = 500
@export_enum("line", "swing") var projectile_type: String = "line"
@onready var player_stats = $"../PlayerStats"
@onready var player_energy_container = $"../EnergyContainer"
@onready var projectile_spawner = $ProjectileSpawner
var time_of_last_attack: float = 0.0
var rarity_ratio: float = 1
@export var base_dex_ratio: float = 1.0
@export var base_atk_ratio: float = 1.0
var dex_ratio: float
var atk_ratio: float
@export var special_energy_cost: float = 5

@onready var knockback_component: KnockbackComponent = get_node_or_null("KnockbackComponent")
@onready var poison_component: PoisonComponent = get_node_or_null("PoisonComponent")


func _ready():
	set_base_values()
	set_rarity_bonuses()
	set_stat_bonuses()
	
	projectile_spawner.set_universal_projectile_attributes(projectile_damage, 
		projectile_speed, projectile_range, projectile_type)
	if knockback_component:
		projectile_spawner.set_knockback_projectile_attributes(knockback_component.effect_active,
		knockback_component.knockback)
	if poison_component:
		projectile_spawner.set_poison_projectile_attributes(poison_component.effect_active,
		poison_component.percent_of_max_health_per_second, poison_component.duration)


func set_base_values():
	dex_ratio = base_dex_ratio
	atk_ratio = base_atk_ratio
	
func set_rarity_bonuses():
	rarity_ratio = weapon_rarity * 0.2 + 1
	dex_ratio *= rarity_ratio
	atk_ratio *= rarity_ratio
	
func set_stat_bonuses():
	attack_speed = float(player_stats.dexterity / 100 * dex_ratio)
	projectile_damage = float(player_stats.power / 10 * atk_ratio)
	
func spend_energy(amount) -> bool:
	return player_energy_container.deplete_energy(amount)

func basic_attack():
	pass
	
func item_special():
	pass
