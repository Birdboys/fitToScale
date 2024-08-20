extends Control
@onready var anim := $splashAnim

func _ready():
	anim.play("splash")

func _on_splash_anim_animation_finished(anim_name):
	if anim_name == "splash":
		pass
		#get_tree().change_scene_to_file("res://Scenes/newlogin.tscn")

func _input(event):
	if event is InputEventMouseButton:
		#AudioHandler.play('ui_click')
		#get_tree().change_scene_to_file("res://Scenes/newlogin.tscn")
		pass
		
func eeeh():
	AudioHandler.playSound("eeeh")
