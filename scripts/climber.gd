extends RigidBody2D

@onready var climberSprite := $climberSprite
@onready var rope := $climberSprite/rope
@onready var climberAnim := $climberAnim
@onready var pathAnim := $pathAnim
@onready var colShape := $colShape
@onready var current_phase := "idle"
@onready var anger_val := 100.0
@onready var anger_loss_rate := 3.0
@onready var distance_travelled := 0.0
@onready var climbing := false

@export var climb_speed := 250.0
@export var climbFollower : PathFollow2D
@export var climbPath : Path2D
@export var climb_curve : Curve
@export var speed_mult := 1.75
@export var rope_starting_length := 10

signal finished_path
signal ready_to_climb
signal fell_off

func _process(delta: float) -> void:
	if climbing: anger_val = clamp(anger_val - anger_loss_rate * delta, 0.0, 100.0)
	match current_phase:
		"climbing":
			var added_progress = climb_curve.sample(climbFollower.progress_ratio) * climb_speed * speed_mult * sqrt(clamp(anger_val/100.0, 0.5, 1.0)) * delta 
			climbFollower.progress += added_progress
			distance_travelled += added_progress/100.0
			global_position = climbFollower.global_position
			if climbFollower.progress_ratio >= 0.95:
				current_phase = "finishing"
				var finish_tween = get_tree().create_tween()
				finish_tween.tween_property(climbFollower, "progress_ratio", 1.0, 0.05)
				finish_tween.tween_callback(finishedPath)
			rotation = climbFollower.rotation + PI
			if pathAnim.is_playing(): pathAnim.seek(pathAnim.current_animation_length * climbFollower.progress_ratio)
		"finishing":
			global_position = climbFollower.global_position
		"falling":
			anger_val = 0.0
	if current_phase != "falling" and anger_val == 0.0:
		fellOff()
		
func startClimbing(path):
	var quad = getAngleQuad(path.angle)
	await getClimbingTechnique(quad)
	climbFollower.reparent(path)
	climbFollower.progress_ratio = 0.0
	current_phase = "climbing"

func finishedPath():
	current_phase = "pausing"
	emit_signal("finished_path")
	climberAnim.stop()
	pathAnim.stop()
	
func hit():
	var hit_tween = get_tree().create_tween()
	hit_tween.tween_property(climberSprite, "self_modulate", Color.REBECCA_PURPLE, 0.0)
	hit_tween.tween_property(climberSprite, "self_modulate", Color.WHITE, 0.5)	
	anger_val += 20
	anger_val = clamp(anger_val, 0, 100)
	$rageParticles.emitting = true
	AudioHandler.playSound2D("climber_hit", global_position)

func initializeRope():
	rope.initialize(rope_starting_length)

func attachPlayer(player):
	rope.attachPlayer(player)
	
func rotateToNextPath(rot):
	if rotation > PI: rotation -= 2*PI
	var new_rot = rot + PI/2
	print("PREV ROT %s, ROT %s" % [rad_to_deg(rotation), rad_to_deg(new_rot)])
	#print("PREV %S, NEW %s" % rotation new_rot)
	#if new_rot >= 2*PI: new_rot -= 2*PI
	var rotate_tween = get_tree().create_tween()
	rotate_tween.tween_property(self, "rotation", new_rot, 0.5 / (anger_val/50))
	await rotate_tween.finished
	return

func getAngleQuad(angle):
	if angle > 0: return 0.0
	elif angle > -PI/4.0: return 1.0
	elif angle > -PI/2.0: return 2.0
	else: return 3.0
	
func getClimbingTechnique(quad : float, force=null):
	var anim_data : ClimberAnim
	if force != null: 
		anim_data = await load("res://scripts/resources/%s.tres" % force)
	else:
		match quad:
			0.0:
				anim_data = await load("res://scripts/resources/ladder_climb.tres")
			1.0:
				anim_data = await load("res://scripts/resources/dyno.tres")
			2.0:
				anim_data = await load("res://scripts/resources/monkey_bar.tres")
			3.0:
				anim_data = await load("res://scripts/resources/monkey_bar.tres")
	
	if anim_data.climber_anim != "": climberAnim.play(anim_data.climber_anim, -1, anim_data.climber_anim_speed_scale)
	if anim_data.path_anim != "": pathAnim.play(anim_data.path_anim, -1, 0.0)
	climb_curve = anim_data.path_curve

func fellOff():
	current_phase = "falling"
	freeze = false
	climberAnim.play("fell_off")
	emit_signal("fell_off")
	await get_tree().create_timer(1.0).timeout
	set_collision_mask_value(1, true)
	set_collision_mask_value(4, true)
	
func mountainSound():
	AudioHandler.playSound2D("climber_mountain", global_position)
