class_name Level
extends Node3D

@onready var obstacles: Node3D = $Obstacles
@onready var bubbles: Node3D = $Bubbles
@onready var initial_player_position: Vector3 = $Player.position

func _ready() -> void:
	Globals.current_level = self

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("reset"):
		Globals.player.position = initial_player_position
