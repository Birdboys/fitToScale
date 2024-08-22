extends CanvasLayer

@onready var current_menu := "hidden"
@onready var playButton := $uiMargin/mainButtons/playButton
@onready var settingsButton := $uiMargin/mainButtons/settingsButton
@onready var creditsButton := $uiMargin/mainButtons/creditsButton
@onready var quitButton := $uiMargin/mainButtons/quitButton

@onready var mainButtons := $uiMargin/mainButtons
@onready var settingsButtons := $uiMargin/settingsButtons
@onready var creditsButtons := $uiMargin/creditsButtons

@onready var prev_mode = Input.MOUSE_MODE_HIDDEN
@onready var was_paused := false
@onready var screenshot_num := 0

func _ready() -> void:
	playButton.pressed.connect(mainButtonPressed.bind("play"))
	settingsButton.pressed.connect(mainButtonPressed.bind("settings"))
	creditsButton.pressed.connect(mainButtonPressed.bind("credits"))
	quitButton.pressed.connect(mainButtonPressed.bind("quit"))
	hideMenu()
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		handleEscape()
	elif Input.is_action_just_pressed("test"):
		screenShot()

func showMenu():
	current_menu = "main"
	was_paused = get_tree().paused 
	get_tree().paused = true
	visible = true
	toggleMain(true)
	toggleCredits(false)
	toggleSettings(false)
	prev_mode = Input.mouse_mode
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func hideMenu():
	current_menu = "hidden"
	get_tree().paused = was_paused
	visible = false
	toggleMain(false)
	toggleCredits(false)
	toggleSettings(false)
	Input.mouse_mode = prev_mode
	
func mainButtonPressed(but):
	AudioHandler.playSound("ui_click")
	match but:
		"play":
			hideMenu()
		"settings":
			current_menu = "settings"
			toggleMain(false)
			toggleSettings(true)
		"credits":
			current_menu = "credits"
			toggleMain(false)
			toggleCredits(true)
		"quit":
			get_tree().quit()

func toggleMain(on: bool):
	mainButtons.visible = on
func toggleCredits(on: bool):
	creditsButtons.visible = on
	
func toggleSettings(on: bool):
	if on: settingsButtons.readySliders()
	settingsButtons.visible = on
	
func handleEscape():
	AudioHandler.playSound("ui_click")
	match current_menu:
		"main": hideMenu()
		"settings":
			current_menu = "main"
			toggleSettings(false)
			toggleMain(true)
		"credits":
			current_menu = "main"
			toggleCredits(false)
			toggleMain(true)
		"hidden": 
			showMenu()
			print("SHOWING MENU")

func screenShot():
	var im = get_viewport().get_texture().get_image()
	var file_name = "user://climb_screenshot_%s" % screenshot_num
	screenshot_num += 1
	im.save_png(file_name)
