extends Node2D

@onready var rock := preload("res://scenes/rock.tscn")
@onready var rocks := $rocks
@onready var camArm := $camArm
@onready var skyBG := $camArm/levelCam/skyBGPoly
@onready var cloudBG1 := $camArm/levelCam/cloudBG1
@onready var cloudBG2 := $camArm/levelCam/cloudBG2
@onready var cloudBG3 := $camArm/levelCam/cloudBG3
@onready var groundPoly := $groundPolygon
@onready var mountainHandler := $mountainHandler
@onready var climber := $climber
@onready var player := $player

var current_path
var prev_path
var prev_rot 

func _ready() -> void:
	climber.finished_path.connect(climberFinishedPath)
	
	initializeBackgrounds()
	attachClimberToMountain()
	
	#AudioHandler.togglePlayer("music", true)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("test"): mountainHandler.getNextPath()
	camArm.global_position = camArm.global_position.move_toward((player.global_position + climber.global_position)/2.0 + Vector2.LEFT * 90, 900.0*delta)
	handleParallax()
	
func initializeBackgrounds():
	var size = get_viewport_rect().size
	var poly = [Vector2(-size.x/2,-size.y/2), Vector2(size.x/2, -size.y/2), Vector2(size.x/2, size.y/2), Vector2(-size.x/2, size.y/2), Vector2(-size.x/2,-size.y/2)]
	skyBG.polygon = poly
	cloudBG1.polygon = poly
	cloudBG2.polygon = poly
	cloudBG3.polygon = poly
	groundPoly.polygon = [Vector2(-size.x, 0), Vector2(size.x, 0), Vector2(size.x, size.y), Vector2(-size.x, size.y), Vector2(-size.x, 0)]

func attachClimberToMountain():
	current_path = mountainHandler.getPath(8)
	climber.global_position = current_path.start_point
	climber.rotation = PI/2
	climber.initializeRope()
	climber.attachPlayer(player)
	player.global_position += Vector2(-250, 100)
	player.summonHand()
	camArm.global_position = (player.global_position + climber.global_position)/2.0 + Vector2.LEFT * 90
	groundPoly.global_position = player.global_position + Vector2(0, 32)
	#player.freeze = true
	#return
	climber.startClimbing(current_path)
	
func climberFinishedPath():
	prev_rot = current_path.angle
	prev_path = current_path
	current_path = current_path.next
	await climber.rotateToNextPath(current_path.angle)
	climber.startClimbing(current_path)
	spawnRock()
	mountainHandler.getNextPath()
	
func spawnRock():
	var rock_normal = (prev_rot + current_path.angle)/2.0 - PI/2.0
	var rock_force = Vector2.UP.rotated(rock_normal + PI/4.0 + randf_range(-PI/8.0, PI/8.0)) * randf_range(500, 700)
	var rock_pos = climber.global_position + Vector2.UP.rotated(rock_normal) * 48
	var new_rock = rock.instantiate()
	rocks.add_child(new_rock)
	new_rock.global_position = rock_pos
	new_rock.fall(rock_force)

func handleParallax():
	cloudBG1.material.set_shader_parameter("cam_pos", camArm.global_position)
	cloudBG2.material.set_shader_parameter("cam_pos", camArm.global_position)
	cloudBG3.material.set_shader_parameter("cam_pos", camArm.global_position)
