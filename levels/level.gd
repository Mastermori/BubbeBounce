class_name Level
extends Node3D

@onready var obstacles: Node3D = $Obstacles
@onready var bubbles: Node3D = $Bubbles
@onready var initial_player_position: Vector3 = $Player.position
@onready var endPopup: GameEndPopup = $GameEndPopup

var gameOver: bool = false

func _ready() -> void:
	Globals.current_level = self
	endPopup.init(restart_level)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("reset"):
		restart_level()
	
func finish(win: bool)-> void:
	if gameOver:
		return
	gameOver = true
	endPopup.show_game_end(win)
	
func restart_level() -> void:
	gameOver = false
	Globals.scene_manager.reload_scene()
	
	
