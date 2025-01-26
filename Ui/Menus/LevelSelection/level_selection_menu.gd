class_name LevelSelectionMenu
extends Control

@onready var level_1_button: Button = $Panel/GridContainer/Button
@onready var level_2_button: Button = $Panel/GridContainer/Button2
@onready var level_3_button: Button = $Panel/GridContainer/Button3
@onready var level_4_button: Button = $Panel/GridContainer/Button4
@onready var level_5_button: Button = $Panel/GridContainer/Button5

@onready var back_button: Button = $Panel/Button

func open() -> void:
	visible = true

	level_1_button.pressed.connect(_on_button_pressed.bind(level_1_button))
	level_2_button.pressed.connect(_on_button_pressed.bind(level_2_button))
	level_3_button.pressed.connect(_on_button_pressed.bind(level_3_button))
	level_4_button.pressed.connect(_on_button_pressed.bind(level_4_button))
	level_5_button.pressed.connect(_on_button_pressed.bind(level_5_button))
	back_button.pressed.connect(_on_back_button)

	
func _on_button_pressed(button: Button) -> void:
	if !button.has_meta("level"):
		print("Button does not have a level assigend")
		return
	_unsubscribe()
	visible = false
	Globals.scene_manager.switch_to_scene(button.get_meta("level"))

func _on_back_button() -> void:
	_unsubscribe()
	visible = false
	
func _unsubscribe() -> void:
	level_1_button.pressed.disconnect(_on_button_pressed)
	level_2_button.pressed.disconnect(_on_button_pressed)
	level_3_button.pressed.disconnect(_on_button_pressed)
	level_4_button.pressed.disconnect(_on_button_pressed)
	level_5_button.pressed.disconnect(_on_button_pressed)
	back_button.pressed.disconnect(_on_back_button)
	
