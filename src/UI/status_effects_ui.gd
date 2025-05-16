class_name StatusEffectsUI
extends Control

@onready var blessed_icon = get_node("HBoxContainer/BlessedIcon")
@onready var poisoned_icon = get_node("HBoxContainer/PoisonedIcon")
@onready var burned_icon = get_node("HBoxContainer/BurnedIcon")
@onready var crippled_icon = get_node("HBoxContainer/CrippledIcon")
@onready var dazed_icon = get_node("HBoxContainer/DazedIcon")
@onready var slowed_icon = get_node("HBoxContainer/SlowedIcon")
@onready var sapped_icon = get_node("HBoxContainer/SappedIcon")

func toggle_blessed_icon():
	blessed_icon.visible = not blessed_icon.visible

func toggle_poisoned_icon():
	poisoned_icon.visible = not poisoned_icon.visible
	
func toggle_burned_icon():
	burned_icon.visible = not burned_icon.visible
	
func toggle_crippled_icon():
	crippled_icon.visible = not crippled_icon.visible

func toggle_dazed_icon():
	dazed_icon.visible = not dazed_icon.visible

func toggle_slowed_icon():
	slowed_icon.visible = not slowed_icon.visible

func toggle_sapped_icon():
	sapped_icon.visible = not sapped_icon.visible
