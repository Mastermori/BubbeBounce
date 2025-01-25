extends Control

@onready var play_button: Button = $Panel/VBoxContainer/PlayButton

func _ready() -> void:
	play_button.pressed.connect(_play)
	
func _play() -> void:
	Globals.scene_manager.switch_to_scene(0)
