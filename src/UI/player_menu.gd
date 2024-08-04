extends CanvasLayer

@onready var health_label : RichTextLabel = $Stats/VBoxContainer/Health
@onready var defense_label : RichTextLabel = $Stats/VBoxContainer/Defense
@onready var hp_regen_label : RichTextLabel = $"Stats/VBoxContainer/HP Regen"
@onready var power_label : RichTextLabel = $Stats/VBoxContainer/Power
@onready var dexterity_label : RichTextLabel = $Stats/VBoxContainer/Dexterity
@onready var speed_label : RichTextLabel = $Stats/VBoxContainer/Speed
@onready var energy_label : RichTextLabel = $Stats/VBoxContainer/Energy
@onready var energy_regen_label : RichTextLabel = $"Stats/VBoxContainer/Energy Regen"
@onready var panel = $Stats
@onready var xp_label : RichTextLabel = $xp/VBoxContainer/xp

func _ready():
	var stats = $"../PlayerStats"
	render_stats()
	stats.connect("player_leveled_up", render_stats)
	stats.connect("player_gained_xp", render_xp)
	$"..".toggle_inventory.connect(toggle_player_menu)

func toggle_player_menu():
	panel.visible = not panel.visible

func render_xp():
	var stats = $"../PlayerStats"
	var player_level = get_player_level()
	xp_label.bbcode_text = "Level " + str(stats.level) + (" MAX" if stats.level == stats.max_level else "") + "\nXP " + str(stats.xp) + "/" + str(stats.xp_level_thresholds[player_level - 1])

func render_stats():
	var stats = $"../PlayerStats"
	health_label.bbcode_text = "Max Health " + str(stats.health) + " (" + ("+" if stats.health_mod >= 0 else "") + str(stats.health_mod) + ")" 
	hp_regen_label.bbcode_text = "HP Regen " + str(stats.hp_regen) + " (" + ("+" if stats.hp_regen_mod >= 0 else "") + str(stats.hp_regen_mod) + ")" 
	defense_label.bbcode_text = "Defense " + str(stats.defense) + " (" + ("+" if stats.defense_mod >= 0 else "") + str(stats.defense_mod) + ")" 
	power_label.bbcode_text = "Power " + str(stats.power) + " (" + ("+" if stats.power_mod >= 0 else "") + str(stats.power_mod) + ")" 
	dexterity_label.bbcode_text = "Dexterity " + str(stats.dexterity) + " (" + ("+" if stats.dexterity_mod >= 0 else "") + str(stats.dexterity_mod) + ")" 
	speed_label.bbcode_text = "Speed " + str(stats.speed) + " (" + ("+" if stats.speed_mod >= 0 else "") + str(stats.speed_mod) + ")" 
	energy_label.bbcode_text = "Energy " + str(stats.energy) + " (" + ("+" if stats.energy_mod >= 0 else "") + str(stats.energy_mod) + ")" 
	energy_regen_label.bbcode_text = "Energy Regen " + str(stats.energy_regen) + " (" + ("+" if stats.energy_regen_mod >= 0 else "") + str(stats.energy_regen_mod) + ")" 
	

func get_player_level():
	var stats = $"../PlayerStats"
	var player_level = stats.level
	if stats.level == stats.max_level:
		player_level = stats.max_level - 1
	return player_level
