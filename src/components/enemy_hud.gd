class_name EnemyHud
extends Node2D

@export var health_container: HealthContainer
@export var hurt_box: HurtBox

@onready var health_bar: ProgressBar = %HealthBar
@onready var status_effects: StatusEffectsUI = %StatusEffectsUI

# Called when the node enters the scene tree for the first time.
func _ready():
	health_bar.max_value = health_container.max_health
	health_bar.value = health_container.health
	health_container.health_changed.connect(adjust_health_bar)
	
	hurt_box.begin_blessed.connect(status_effects.toggle_blessed_icon)
	hurt_box.end_blessed.connect(status_effects.toggle_blessed_icon)
	hurt_box.begin_poisoned.connect(status_effects.toggle_poisoned_icon)
	hurt_box.end_poisoned.connect(status_effects.toggle_poisoned_icon)
	hurt_box.begin_burned.connect(status_effects.toggle_burned_icon)
	hurt_box.end_burned.connect(status_effects.toggle_burned_icon)
	hurt_box.begin_crippled.connect(status_effects.toggle_crippled_icon)
	hurt_box.end_crippled.connect(status_effects.toggle_crippled_icon)

func adjust_health_bar(_amount):
	health_bar.value = health_container.health
