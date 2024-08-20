extends Node2D
@onready var segment := preload("res://scenes/rope_segment.tscn")
@onready var segments = [$ropeHolder, $ropeSegment]
@onready var head_link := $ropeSegment
@onready var last_link := $ropeSegment
@onready var ropeLine := $ropeLine
@onready var segment_length := 32
@export var ropeJoint : PinJoint2D

var player_joint : PinJoint2D
# Called when the node enters the scene tree for the first time.
signal rope_ready

func _ready() -> void:
	ropeLine.points = segments.map(func(seg): return seg.position)
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta: float) -> void:
	for x in range(len(ropeLine.points)):
		ropeLine.points[x] = ropeLine.points[x].move_toward(segments[x].position, 1000.0 * delta)

	#print(ropeLine.points)
func initialize(starting_length):
	for x in range(starting_length-1):
		addLink()
	emit_signal("rope_ready")

func addLink():
	var new_pos = last_link.global_position + Vector2.DOWN * segment_length * 0.9
	var new_joint_pos = last_link.global_position + Vector2.DOWN * segment_length * 0.9 / 2.0
	var new_link = segment.instantiate()
	var new_joint = ropeJoint.duplicate()
	add_child(new_joint)
	add_child(new_link)
	segments.append(new_link)
	new_link.global_position = new_pos
	new_joint.global_position = new_joint_pos
	new_joint.node_a = last_link.get_path()
	new_joint.node_b = new_link.get_path()
	ropeLine.add_point(new_link.position)
	last_link = new_link

func getLastSegment():
	return last_link

func attachPlayer(player):
	if player_joint:
		player_joint.queue_free()
		player_joint = null
	var new_joint_pos = last_link.global_position + Vector2.DOWN * segment_length/2.0
	player_joint = PinJoint2D.new()
	#new_joint.softness = 0.1
	add_child(player_joint)
	player_joint.global_position = new_joint_pos
	player.global_position = player_joint.global_position + Vector2.DOWN * player.playerSprite.texture.get_height()/4.0
	player_joint.node_a = last_link.get_path()
	player_joint.node_b = player.get_path()
	
