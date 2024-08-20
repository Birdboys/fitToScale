extends Path2D

@onready var colShape := $mountainCol/colShape 
@onready var mountainCol := $mountainCol
@onready var pathLine := $pathLine
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
