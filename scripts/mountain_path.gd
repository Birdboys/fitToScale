extends Path2D

@onready var colShape := $mountainCol/colShape 
@onready var mountainCol := $mountainCol
@onready var pathLine := $pathLine
@onready var rockLine := $rockLine
@onready var max_line_offset := 16
@onready var path_line_points := 8
var start_point : Vector2
var end_point : Vector2
var angle : float
var next : Path2D

func initialize(length, rot):
	var end = Vector2.UP.rotated(rot) * length
	curve = Curve2D.new()
	curve.clear_points()
	curve.add_point(Vector2(0,0))
	curve.add_point(end)
	pathLine.points = [Vector2(0, 0),end]
	start_point = to_global(Vector2(0,0))
	end_point = to_global(end)
	
	var seg = SegmentShape2D.new()
	seg.a = Vector2(0, 0)
	seg.b = Vector2(end.x, end.y)
	colShape.shape = seg
	angle = rot
	
	createPathLine()

func createPathLine():
	var new_points = [Vector2(0,0)]
	var offset_vector = Vector2.UP.rotated(angle + PI/2)
	for x in range(1, path_line_points-1):
		print(float(x+1)/float(path_line_points))
		var og_point = to_local(end_point) * float(x)/float(path_line_points)
		new_points.append(og_point + offset_vector * int(randf_range(-1.0,1.0) * max_line_offset))
	new_points.append(to_local(end_point))
	rockLine.points = new_points
