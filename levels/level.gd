class_name Level
extends Node3D

@onready var obstacles: Node3D = $Obstacles
@onready var bubbles: Node3D = $Bubbles
@onready var initial_player_position: Vector3 = $Player.position
@onready var endPopup: GameEndPopup = $GameEndPopup
@onready var timer: Timer = $Timer

var gameOver: bool = false
var bubbleCounter: int = 0

func _ready() -> void:
	gameOver = false
	bubbleCounter = 0
	get_tree().paused = false
	Globals.current_level = self
	endPopup.init(restart_level)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("reset"):
		restart_level()
	
func finish(win: bool)-> void:
	if gameOver:
		return
	gameOver = true
	get_tree().paused = true
	if(!win):
		timer.start()
		return
	endPopup.show_game_end(win)
	bubbleCounter = 0

func open_fail_popup():
	endPopup.show_game_end(false)
	bubbleCounter = 0
	
func restart_level() -> void:
	Globals.scene_manager.reload_scene()
	
	
