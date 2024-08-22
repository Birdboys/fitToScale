extends Node2D

@export var anger_val := 0.0
@onready var head := $head
@onready var mouthCorners := $mouthCorners
@onready var browCorners := $browCorners
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func moveFace(val):
	anger_val = val
	head.modulate = Color(174.0/255.0, 93.0/255.0, 64.0/255.0, 1.0).blend(Color(186.0/255.0, 145.0/255.0, 88.0/255.0, (1.0-anger_val)))# * (1.0-anger_val) + Color.hex(0xae5d40) * anger_val
	head.modulate.a = 255
	mouthCorners.offset.y = remap(anger_val, 0.0, 1.0, -6, 0.0)
	browCorners.offset.y = remap(anger_val, 0.0, 1.0, 6.0, 0.0)
