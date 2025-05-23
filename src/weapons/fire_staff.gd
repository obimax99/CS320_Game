extends Weapon

var item_special_duration: float = 5.0
var aoe_explosion: bool = false


func _ready():
	super._ready()
	projectile_spawner.projectile_aoe_explosion = aoe_explosion


func basic_attack():
	var current_time = Time.get_ticks_msec() / 1000.0

	if (current_time - time_of_last_attack) < 1/attack_speed:
		return
	time_of_last_attack = current_time
	var direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	projectile_spawner.spawn_projectile(direction)


func item_special():
	if aoe_explosion == true:
		return
	if (!spend_energy(special_energy_cost)):
		return
	aoe_explosion = true;
	projectile_spawner.projectile_aoe_explosion = aoe_explosion
	print("aoe on!")
	await get_tree().create_timer(item_special_duration).timeout
	aoe_explosion = false;
	projectile_spawner.projectile_aoe_explosion = aoe_explosion
	print("aoe off!")
