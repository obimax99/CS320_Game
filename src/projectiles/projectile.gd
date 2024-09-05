extends Node2D
class_name Projectile

var projectile_direction: Vector2 = Vector2(0.0, 0.0)
var projectile_speed: float = 100
var projectile_damage: float = 10
var projectile_range: float = 50
var projectile_type: String = "line"
var aoe_explosion: bool = false
@onready var sprite: Sprite2D = $Sprite2D
@onready var hit_box: HitBox = $HitBox
@onready var projectile_lifetime = projectile_range / projectile_speed
var swing_projectile_arc_degrees: float = 90

func _ready():
	hit_box.set_damage(projectile_damage)
	if projectile_type == "swing":
		projectile_lifetime = swing_projectile_arc_degrees / projectile_speed
		if abs(rotation) < PI / 2:
			rotation_degrees -= (swing_projectile_arc_degrees/2)
		else:
			rotation_degrees += (swing_projectile_arc_degrees/2)
			swing_projectile_arc_degrees *= -1
	await get_tree().create_timer(projectile_lifetime).timeout
	queue_free()

func _process(_delta):
	if projectile_type == "line":
		position += projectile_direction * _delta * projectile_speed
	elif projectile_type == "swing":
		rotation_degrees += _delta / projectile_lifetime * swing_projectile_arc_degrees
		position = Vector2.from_angle(rotation) * projectile_range
