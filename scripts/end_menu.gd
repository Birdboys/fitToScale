extends CanvasLayer
@onready var playButton := $uiMargin/VBoxContainer/buttons/playButton
@onready var quitButton := $uiMargin/VBoxContainer/buttons/quitButton 
@onready var played_again := false

var score_val
func _ready() -> void:
	AudioHandler.playSound("ui_click")
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
	$uiMargin/VBoxContainer/Label2.text = str(score_val)
	
func _on_play_button_pressed() -> void:
	AudioHandler.playSound("ui_click")
	if not played_again:
		get_tree().paused = false
		played_again = true
		queue_free()
		get_tree().change_scene_to_file("res://scenes/endless_level_scene.tscn")

func _on_quit_button_pressed() -> void:
	AudioHandler.playSound("ui_click")
	get_tree().quit()
