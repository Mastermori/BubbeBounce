class_name Level
extends Node3D

@onready var obstacles: Node3D = $Obstacles
@onready var bubbles: Node3D = $Bubbles

func _ready() -> void:
	Globals.current_level = self
