extends Weapon

@export var basic_projectile_arc_degrees: float = 90
var time_of_last_special: float = 0.0
var special_delay: float
var special_projectile_damage: float
@export var special_projectile_arc_degrees: float = 360


func _ready():
	super._ready()
	special_projectile_damage = projectile_damage * 8
	special_delay = attack_speed / 2

func basic_attack():
	var current_time = Time.get_ticks_msec() / 1000.0
	if (current_time - time_of_last_attack) < 1/attack_speed:
		return
	time_of_last_attack = current_time
	
	var direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	projectile_spawner.spawn_melee_projectile(direction, false)

func item_special():
	var current_time = Time.get_ticks_msec() / 1000.0
	if (current_time - time_of_last_special) < 1/special_delay:
		return
	if (!spend_energy(special_energy_cost)):
		return
	time_of_last_special = current_time
	
	projectile_spawner.projectile_damage = special_projectile_damage
	projectile_spawner.projectile_speed *= 3
	projectile_spawner.swing_projectile_arc_degrees = special_projectile_arc_degrees
	var direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	projectile_spawner.spawn_melee_projectile(direction, false)
	projectile_spawner.projectile_damage = projectile_damage
	projectile_spawner.swing_projectile_arc_degrees = basic_projectile_arc_degrees
	projectile_spawner.projectile_speed /= 3
	
