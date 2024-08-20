extends Node2D

@onready var mountainPath := preload("res://scenes/mountain_path.tscn")
@onready var screen_width : int
@onready var screen_height : int
@onready var path_queue := []
@onready var path_points := []
@onready var paths := $mountainPaths
@onready var mountainMesh := $mountainMesh
@onready var mountainOccluder := $mountainOccluder

var prev_path
var prev_angle
var path_length_min := 150.0
var path_length_max := 450.0
var path_queue_length := 20
var path_angle_min := -3.0*PI/4.0 
var path_angle_max := PI/4.0
var path_random_offset := PI

func _ready() -> void:
	screen_width = get_viewport_rect().size.x
	screen_height = get_viewport_rect().size.y
	startMountain()
	
func startMountain():
	prev_path = mountainPath.instantiate()
	prev_angle = 0.0
	paths.add_child(prev_path)
	path_queue.append(prev_path)
	prev_path.initialize(300.0, 0.0)
	path_points.append(Vector2(prev_path.start_point))
	path_points.append(Vector2(prev_path.end_point))
	for x in range(1, 10):
		getNewPathSegment(0.0)
		
	for x in range(11, path_queue_length):
		getNewPathSegment()
		
	updateMesh()
	
func updateMesh():
	var pathers = path_points.duplicate()
	var max_x = pathers[0].x
	var min_y = pathers[0].y
	for p in pathers:
		if p.x > max_x: max_x = p.x
		if p.y < min_y: min_y = p.y
	pathers.append(Vector2(pathers[-1].x, min_y-screen_height))
	pathers.append(Vector2(max_x+screen_width, pathers[-1].y))
	pathers.append(Vector2(pathers[-1].x, pathers[0].y))
	pathers.append(pathers[0])
	mountainMesh.polygon = pathers
	#mountainOccluder.occluder.polygon = pathers

func getNewPathSegment(force_angle = null):
	var new_path = mountainPath.instantiate()
	var new_path_length = randi_range(path_length_min,path_length_max)
	var new_path_angle 
	if force_angle != null: new_path_angle = force_angle
	else:
		var new_angle_min = clamp(prev_angle - deg_to_rad(65), path_angle_min, path_angle_max ) 
		var new_angle_max = clamp(prev_angle + deg_to_rad(65), path_angle_min, path_angle_max ) 
		new_path_angle = randf_range(new_angle_min, new_angle_max)
	paths.add_child(new_path)
	path_queue.append(new_path)
	new_path.global_position = prev_path.end_point
	new_path.initialize(new_path_length, new_path_angle)
	path_points.append(Vector2(new_path.end_point))
	prev_path.next = new_path
	prev_path = new_path
	prev_angle = new_path.angle

func getNextPath():
	path_queue[0].queue_free()
	path_queue.remove_at(0)
	path_points.remove_at(0)
	getNewPathSegment()
	updateMesh()
	
func getPath(id):
	return path_queue[id]
