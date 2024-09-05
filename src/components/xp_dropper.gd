extends Node2D

@onready var spawner_node = $Spawner

@export_range(10,200,10) var xp_drop_amount: int = 10
var num_orbs: int = 0

func drop_xp():
	num_orbs = floor(xp_drop_amount) / 10
	for i in range (0, num_orbs):
		spawner_node.spawn()
