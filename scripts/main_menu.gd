extends Control

@onready var mainAnim := $mainAnim
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioHandler.togglePlayer("music", true)
	mainAnim.play("flicker")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("grab"): get_tree().change_scene_to_file("res://scenes/endless_level_scene.tscn")
