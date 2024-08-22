extends CharacterBody2D

@onready var pickupHitbox := $pickupHitbox
@onready var handSprite := $handSprite
@onready var current_phase := "open"
@export var throw_force_mult := 100.0
@export var hand_speed_max := 2500.0
@export var hand_speed_min := 100.0
@export var max_hand_dist := 250.0
@export var throw_mult := 100.0
@export var pull_force_mult := 250000.0
@export var cam : Camera2D
@export var player : RigidBody2D
var prev_screen_pos : Vector2
var curr_sreen_pos : Vector2
var rock

signal pull_force(f, d)
# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match current_phase:
		"open":
			if Input.is_action_just_pressed("grab"): grab()
		"pulling":
			pass
			#if Input.is_action_just_released("grab"): release()
			#
		"holding":
			if Input.is_action_just_released("grab"): release()
			prev_screen_pos = curr_sreen_pos
			curr_sreen_pos = cam.to_local(global_position)
			
	var pos = get_global_mouse_position()
	var distance = clamp((global_position.distance_to(pos)/max_hand_dist), 0.0, 1.0)
	velocity =  global_position.direction_to(pos) * sqrt(distance) * hand_speed_max
	move_and_slide()
	#global_position = global_position.move_toward(pos,sqrt(distance) * hand_speed_max * delta)
	if player.global_position.distance_to(global_position) > max_hand_dist:
			global_position = player.global_position + player.global_position.direction_to(global_position) * max_hand_dist
	handSprite.look_at(player.global_position)
	handSprite.rotation -= PI/2
	getPullForce(delta)
	
func getPullForce(delta):
	var distance = clamp(player.global_position.distance_to(global_position)/max_hand_dist, 0.0, 1.0)
	var direction = player.global_position.direction_to(global_position)
	var force = sqrt(distance) * pull_force_mult * direction
	emit_signal("pull_force", force, delta)
	
func grab():
	if len(pickupHitbox.get_overlapping_areas()) > 0:
		rock = pickupHitbox.get_overlapping_areas()[0].get_parent()
		rock.reparent(self)
		rock.pickedUp()
		rock.global_position = global_position + Vector2(0, -32)
		current_phase = "holding"
		AudioHandler.playSound2D("rock_catch", global_position)
	
func release():
	match current_phase:
		"pulling":
			current_phase = "open"
		"holding":
			AudioHandler.playSound2D("rock_throw", global_position)
			var throw_force = (curr_sreen_pos - prev_screen_pos) * throw_force_mult
			rock.reparent(get_tree().root)
			rock.thrown(throw_force)
			current_phase = "open"
	
func togglePickup(on: bool):
	pickupHitbox.monitoring = false
	pickupHitbox.monitorable = false
