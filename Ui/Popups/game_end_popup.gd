class_name GameEndPopup
extends Control

@onready var content: Control = $Content

@onready var winContent: Control = $Content/WinContainer
@onready var winBackToMenuButton: Button = $Content/WinContainer/BackToMenuButton
@onready var nextLevelButton: Button = $Content/WinContainer/NextLevelButton

@onready var loseContent: Control = $Content/LoseContainer
@onready var loseBackToMenuButton: Button = $Content/LoseContainer/BackToMenuButton
@onready var tryAgainButton: Button = $Content/LoseContainer/TryAgainButton	

@onready var _game_end_emitter: AudioStreamPlayer3D = $game_end_emitter

var try_again_callback: Callable

func _ready() -> void:
	visible = false

func init(try_again_callback: Callable) -> void:
	self.try_again_callback = try_again_callback

func _disconnect_listeners() -> void:
	if winBackToMenuButton.pressed.has_connections():
		winBackToMenuButton.pressed.disconnect(_on_back_to_menu)
	
	if nextLevelButton.pressed.has_connections():
		nextLevelButton.pressed.disconnect(_on_next_level)
	
	if loseBackToMenuButton.pressed.has_connections():
		loseBackToMenuButton.pressed.disconnect(_on_back_to_menu)
	
	if tryAgainButton.pressed.has_connections():
		tryAgainButton.pressed.disconnect(_on_try_again)

func _exit_tree() -> void:
	_disconnect_listeners()

func show_game_end(win: bool) -> void:
	visible = true
	if win:
		winContent.visible = true
		loseContent.visible = false
		winBackToMenuButton.pressed.connect(_on_back_to_menu)
		nextLevelButton.pressed.connect(_on_next_level)
		_game_end_emitter.play()
		_game_end_emitter.get_stream_playback().switch_to_clip(1)
	else:
		loseContent.visible = true
		winContent.visible = false
		loseBackToMenuButton.pressed.connect(_on_back_to_menu)
		tryAgainButton.pressed.connect(_on_try_again)
		_game_end_emitter.play()
		_game_end_emitter.get_stream_playback().switch_to_clip(0)

func _on_back_to_menu() -> void:
	visible = false
	loseContent.visible = false
	winContent.visible = false
	Globals.scene_manager.back_to_menu()

func _on_next_level() -> void:
	visible = false
	loseContent.visible = false
	winContent.visible = false
	Globals.scene_manager.next_level()

func _on_try_again() -> void:
	_disconnect_listeners()
	visible = false
	loseContent.visible = false
	winContent.visible = false
	try_again_callback.call()
