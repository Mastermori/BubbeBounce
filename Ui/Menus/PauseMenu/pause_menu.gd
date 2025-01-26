extends Control

@onready var continueButton: TextureButton = $Panel/VBoxContainer/Continue
@onready var backToMenuButton: TextureButton = $Panel/VBoxContainer/BackToMenu

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("ui_cancel"):
		if !_can_open():
			return
		_open()

func _open() -> void:
	self.visible = true
	get_tree().paused = true
	continueButton.pressed.connect(_continue)
	backToMenuButton.pressed.connect(_back_to_menu)

func _continue() -> void:
	_unsubscribe_listeners()
	self.visible = false
	get_tree().paused = false

func _back_to_menu() -> void:
	_unsubscribe_listeners()
	self.visible = false
	Globals.scene_manager.back_to_menu()
	
func _unsubscribe_listeners() -> void:
	continueButton.pressed.disconnect(_continue)
	backToMenuButton.pressed.disconnect(_back_to_menu)
	
func _can_open() -> bool:
	return Globals.current_level != null && !Globals.current_level.gameOver
