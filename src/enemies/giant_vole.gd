extends CharacterBody2D

var home := Node2D.new()
var sync_pos : Vector2
var mult_sync: MultiplayerSynchronizer
var first_frame := true

var _rand_target_mod := Vector2((randf() * 2 - 1) * 10, (randf() * 2 - 1) * 10)
var _target: Node2D

@onready var motion_controller: MotionController = %MotionController
@onready var col_detector: Area2D = %ColliderDetector
@onready var xp_dropper = $xp_dropper


func _ready():
	if multiplayer.is_server():
		home.global_position = global_position
	motion_controller.max_speed += (randf() * 2 - 1) * 10


func _physics_process(_delta):
	if mult_sync.get_multiplayer_authority() == multiplayer.get_unique_id():
		_target = col_detector.get_closest_collider()
		_target = home if _target == null else _target 
	
		var new_target = _target.global_position + _rand_target_mod
		
		motion_controller.move(global_position.direction_to(new_target), _delta)
		velocity = motion_controller.velocity
		move_and_slide()
		
		sync_pos = global_position
		
		if first_frame:
			set_spawn_location.rpc(global_position)
			first_frame = false
		
	else:
		global_position = global_position.lerp(sync_pos, 0.4)


func _on_health_container_health_depleted():
	$ItemDropper.drop()
	xp_dropper.drop_xp()
	%DeathAnimator.animate()
	queue_free()


func _on_hurt_box_hurt(_hit_box):
	$volehurt.play()


func _on_tree_entered():
	set_physics_process(false)
	mult_sync = %VoleSync
	mult_sync.set_multiplayer_authority(1)


@rpc("any_peer")
func set_spawn_location(spawn_location):
	home.global_position = spawn_location
	global_position = spawn_location
	sync_pos = global_position
	set_physics_process(true)
