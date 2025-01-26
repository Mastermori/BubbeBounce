extends Control

@onready var play_button: Button = $Panel/HBoxContainer/PlayButton
@onready var level_selection_button: Button = $Panel/HBoxContainer/LevelSelection
@onready var level_selection_componet: LevelSelectionMenu = $LevelSelectionMenu

func _ready() -> void:
	play_button.pressed.connect(_play)
	level_selection_button.pressed.connect(_open_level_selection)
	
func _play() -> void:
	Globals.scene_manager.switch_to_scene(0)

func _open_level_selection() -> void:
	level_selection_componet.open()
