extends Shortbow


# Called when the node enters the scene tree for the first time.
func _ready():
	weapon_rarity = 6
	super._ready()
	special_angle = 350
	num_special_bolts = 35
	num_special_bolts = num_special_bolts-1
	angle_per_bolt = special_angle/(num_special_bolts)
