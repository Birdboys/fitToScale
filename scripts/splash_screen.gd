extends Control
@onready var anim := $splashAnim

func _ready():
	anim.play("splash")

func _on_splash_anim_animation_finished(anim_name):
	if anim_name == "splash":
		AudioHandler.playSound("ui_click")
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _input(event):
	if event is InputEventMouseButton or event is InputEventKey:
		AudioHandler.playSound("ui_click")
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
func eeeh():
	AudioHandler.playSound("eeeh")
