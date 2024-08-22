extends VBoxContainer
@onready var soundSlider := $soundSlider/soundBar
@onready var musicSlider := $musicSlider/musicBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	soundSlider.drag_ended.connect(setAudio)
	musicSlider.drag_ended.connect(setMusic)

func readySliders():
	soundSlider.value = db_to_linear(AudioServer.get_bus_volume_db(1)) * 100
	musicSlider.value = db_to_linear(AudioServer.get_bus_volume_db(2)) * 100

func setAudio(changed):
	if changed:
		var val = soundSlider.value
		AudioServer.set_bus_volume_db(1, linear_to_db(val/100.0))
		AudioHandler.playSound("ui_click")
	
func setMusic(changed):
	if changed:
		var val = musicSlider.value
		AudioServer.set_bus_volume_db(2, linear_to_db(val/100.0))
		AudioHandler.playSound("ui_click")
