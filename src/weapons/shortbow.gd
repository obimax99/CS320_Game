extends Weapon
class_name Shortbow

var time_of_last_special = 0.0
var special_delay = 0.3
var special_angle: float = 40
var num_special_bolts: int = 7
var angle_per_bolt: float

func _ready():
	super._ready()
	num_special_bolts = num_special_bolts-1
	angle_per_bolt = special_angle/(num_special_bolts)

func basic_attack():
	var current_time = Time.get_ticks_msec() / 1000.0

	if (current_time - time_of_last_attack) < 1/attack_speed:
		return
	time_of_last_attack = current_time
	var direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	projectile_spawner.spawn_projectile(direction)
	
func item_special():
	var current_time = Time.get_ticks_msec() / 1000.0
	if (current_time - time_of_last_special) < special_delay:
		return
	if (!spend_energy(special_energy_cost)):
		return
	time_of_last_special = current_time
	var dir: Vector2 = (get_global_mouse_position() - global_position).normalized().rotated(deg_to_rad(-1*(special_angle/2)))
	projectile_spawner.spawn_projectile(dir)
	for ii in (num_special_bolts):
		dir = dir.rotated(deg_to_rad(angle_per_bolt))
		projectile_spawner.spawn_projectile(dir)
